//
//  PCMDataPlayer.m
//  VoicePlayDemo
//
//  Created by 小龙 on 2018/11/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import "PCMDataPlayer.h"
#import <AVFoundation/AVFoundation.h>

#define MIN_SIZE_PER_FRAME 5000   //每个包的大小,室内机要求为960,具体看下面的配置信息
#define QUEUE_BUFFER_SIZE  3      //缓冲器个数
#define SAMPLE_RATE        16000 //采样频率

@interface PCMDataPlayer() {
    AudioQueueRef audioQueue;                                 //音频播放队列
    AudioStreamBasicDescription _audioDescription;
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE]; //音频缓存
    BOOL audioQueueBufferUsed[QUEUE_BUFFER_SIZE];             //判断音频缓存是否在使用
    NSLock *sysnLock;
    OSStatus osState;
    unsigned int temPaket; //切割的数据包的大小
}
/// 播放数据源
@property(nonatomic,strong,nullable)NSMutableArray * dataArray;
/// 播放进度单位为s
@property(nonatomic,assign)NSInteger playPosition;
/// 播放的过程中因为数据不足而暂停
@property(nonatomic,assign,getter=isPausePlayIfNeed)BOOL pausePlayIfNeed;
/// 是否缓存完成
@property(nonatomic,assign,getter=isFinished)BOOL finished;
/// 是否准备好开始播放
@property(nonatomic,assign,getter=isReadyToPlay)BOOL readyToPlay;
@end
@implementation PCMDataPlayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        sysnLock = [[NSLock alloc]init];
        //设置音频参数 具体的信息需要问后台
        
        _audioDescription.mSampleRate = SAMPLE_RATE;
        temPaket = 3200;
        
        _audioDescription.mFormatID = kAudioFormatLinearPCM;
        // 下面这个是保存音频数据的方式的说明，如可以根据大端字节序或小端字节序，浮点数或整数以及不同体位去保存数据
        _audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        //1单声道 2双声道
        _audioDescription.mChannelsPerFrame = 1;
        //每一个packet一侦数据,每个数据包下的桢数，即每个数据包里面有多少桢
        _audioDescription.mFramesPerPacket = 1;
        //每个采样点16bit量化 语音每采样点占用位数
        _audioDescription.mBitsPerChannel = 16;
        _audioDescription.mBytesPerFrame = (_audioDescription.mBitsPerChannel / 8) * _audioDescription.mChannelsPerFrame;
        //每个数据包的bytes总数，每桢的bytes数*每个数据包的桢数
        _audioDescription.mBytesPerPacket = _audioDescription.mBytesPerFrame * _audioDescription.mFramesPerPacket;
        // 使用player的内部线程播放 新建输出
        AudioQueueNewOutput(&_audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, 0, 0, &audioQueue);
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        // 设置音量
        AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1.0);
        // 初始化需要的缓冲区
        [self initPlayBuffer];
        _playPosition = 0;
        _pausePlayIfNeed = NO;
    }
    return self;
}

// MARK: 播放逻辑控制

- (void)initPlayBuffer {
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        audioQueueBufferUsed[i] = false;
        osState = AudioQueueAllocateBuffer(audioQueue, temPaket, &audioQueueBuffers[i]);
    }
}

- (void)startPlay {
    osState = AudioQueueStart(audioQueue, NULL);
    if (osState != noErr) {
        return;
    }
}

- (void)stopPlay {
    osState = AudioQueueStop(audioQueue, YES);
    if (osState != noErr) {
        return ;
    }
}

- (void)appendData:(NSData *)data endFlag:(BOOL)endflag {
    
    NSArray *dataArray = [self arrayWithPcmData:data];
    [self.dataArray addObjectsFromArray:dataArray];
    
    self.finished = endflag;
    
    // 中断后继续播放
    if (self.isPausePlayIfNeed) {
        [self startPlay];
        self.pausePlayIfNeed = NO;
    }
    
    // 准备播放
    if (self.dataArray.count > 0 && self.readyToPlay == NO) {
        self.readyToPlay = YES;
        [self enqueueTheBuffer];
    }

}
// 把数据按照指定的长度切割成指定的长度
- (NSArray *)arrayWithPcmData:(NSData *)data {
    NSMutableArray *tempDataArray = [NSMutableArray array];
    NSInteger count= data.length/temPaket + 1;
    for (int i = 0; i < count; i++) {
        NSData *subData ;
        if (i ==count-1) {
            subData  =[data subdataWithRange:NSMakeRange(i*temPaket, data.length-i*temPaket)];
        }else {
            subData  = [data subdataWithRange:NSMakeRange(i*temPaket, temPaket)];
        }
        // mark: 如果切割的数据为空，不要添加到buffer中来
        if (subData.length<=0) {
            continue;
        }
        [tempDataArray addObject:subData];
    }
    return tempDataArray;
}

- (void)enqueueTheBuffer {
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (!audioQueueBufferUsed[i]) {
           [self  dataEnqueTheAudioBufferIndex:i];
        }
    }
}

- (void)dataEnqueTheAudioBufferIndex:(NSInteger)bufferIndex {
    [sysnLock lock];
    audioQueueBufferUsed[bufferIndex] = false;
    NSData * tempData;
    if(self.dataArray.count <= _playPosition) {
        Byte *bytes = (Byte*)malloc(temPaket);
        tempData  = [NSData dataWithBytes:bytes length:temPaket];
    }else {
        tempData  = self.dataArray[_playPosition];
    }
    
    NSUInteger len = tempData.length;
    Byte *bytes = (Byte*)malloc(len);
    [tempData getBytes:bytes length:len];
    audioQueueBuffers[bufferIndex] -> mAudioDataByteSize =  (unsigned int)len;
    // 把bytes的头地址开始的len字节给mAudioData
    memcpy(audioQueueBuffers[bufferIndex] -> mAudioData, bytes, len);
    if (bytes) {
        free(bytes);
    }
    _playPosition++;
    audioQueueBufferUsed[bufferIndex] = true;
    AudioQueueEnqueueBuffer(audioQueue, audioQueueBuffers[bufferIndex], 0, NULL);
    [sysnLock unlock];
}
// ************************** 回调 **********************************

// 回调回来把buffer状态设为未使用
static void AudioPlayerAQInputCallback(void* inUserData,AudioQueueRef audioQueueRef, AudioQueueBufferRef audioQueueBufferRef) {
    
    PCMDataPlayer* player = (__bridge PCMDataPlayer*)inUserData;
    
    [player resetBufferState:audioQueueRef and:audioQueueBufferRef];
}

- (void)resetBufferState:(AudioQueueRef)audioQueueRef and:(AudioQueueBufferRef)audioQueueBufferRef {
    if (self.dataArray.count == _playPosition) {
        if (self.isFinished) {
            self.pausePlayIfNeed = NO;
            [self stopPlay];
        }else {
            self.pausePlayIfNeed = YES;
        }
        
    }
         // 将这个buffer设为未使用
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (audioQueueBufferRef == audioQueueBuffers[i]) {
            // 追加buffer数据
            [self dataEnqueTheAudioBufferIndex:i];

        }
    }
  
    
}

// ************************** 内存回收 **********************************

- (void)dealloc {

    if (audioQueue != nil) {
        AudioQueueStop(audioQueue,true);
    }
    
    audioQueue = nil;
    sysnLock = nil;
}



// MARK: - custom Accessor -

- (NSInteger)currentPlayPosition {
    return self.playPosition/10;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
