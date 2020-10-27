//
//  DBASRVC.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/9/21.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "DBASRVC.h"
#import <DBASRFramework/DBFileRecognizer.h>
#import <DBCommon/DBCommonConst.h>
#import <DBASRFramework/DBRawDataRecognizer.h>
static NSString * recordFileName = @"record";

@interface DBASRVC ()<DBVoiceRecognizeDelgate>

/// 文件识别器
@property(nonatomic,strong)DBFileRecognizer * fileRecognizer;
/// 元数据识别器
@property(nonatomic,strong)DBRawDataRecognizer * rawDataRecognizer;

@property(nonatomic,strong)NSMutableData * recordData;
@property(nonatomic,assign)NSInteger pcmIndex;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@property (nonatomic) NSUInteger hasReadFileSize;
@property (nonatomic) int sizeToRead;
@property (nonatomic, retain) NSFileHandle *fileHandle;
@property (nonatomic, retain) NSThread *fileReadThread;
@property (nonatomic, retain) NSString *filePath;


@end

@implementation DBASRVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.client = [DBRecognitionManager sharedInstance];

    self.recognitionManager.timeOut = 15;
    self.recognitionManager.log = YES;
//    [self.recognitionManager setupClientId:@"3187ba62-e58d-4bf7-b7be-71252b6d4612" clientSecret:@"MmMzNTA2YTMtZjUyOC00MjcxLTg5ZTItMGMxNjQxOGM4ZGVm" failureHandler:^(BOOL ret, NSString * _Nonnull message) {
//        if (ret) {
//            NSLog(@"鉴权成功");
//        }else {
//            NSLog(@"鉴权失败");
//        }
//    }];

    // 私有化部署
//    [self.recognitionManager setupPrivateDeploymentURL:@"ws://192.168.1.21:9009"];
//    [self.recognitionManager setupPrivateDeploymentURL:@"wss://asr.data-baker.com/"];

    self.pcmIndex = 0;
    self.recordData = [NSMutableData data];
    [self addBorderOfView:self.resultTextView];
    [self addBorderOfView:self.statusTextView];
}

//开始识别
- (IBAction)recordAction:(id)sender {
    [self startRecognize];
}

-  (void)startRecognize {
    [self.recordData resetBytesInRange:NSMakeRange(0, self.recordData.length)];
    [self.recordData setLength:0];
    self.pcmIndex= 0;
    self.statusTextView.text = @"";
    self.resultTextView.text = @"";
    //    [self.client setParamsKey:@"add_pct" paramsValue:@1];
    
    NSInteger ret = [self.recognitionManager startVoiceRecognition:self];
    
    if (ret != 500) {
        NSLog(@"初始化识别失败 错误码%@",@(ret));
        NSString *errorMsg = [self paraseErrorMessageByCode:ret];
        NSString *msg= [NSString stringWithFormat:@"%@ 错误码%@",errorMsg,@(ret)];
        [self appendLogMessage:msg];
    }else {
        [self appendLogMessage:@"初始化识别环境成功"];
    }
}

- (NSString *)paraseErrorMessageByCode:(NSInteger)code {
    NSDictionary *parameters = @{
    @(DBErrorNetworkUnusabel):@"本地网络不可用",
    @(DBErrorStateRecordPermission):@"没有录音权限",
};
return parameters[@(code)];
}
//结束识别
- (IBAction)endRecord:(id)sender {
    [self.recognitionManager stopVoiceRecognition];
    self.statusTextView.text = @"";
    self.resultTextView.text = @"";
}


// MARK: 识别pcm的音频文件
- (void)recognizeFileAction:(UIButton *)sender {
    self.resultTextView.text = @"";
    self.statusTextView.text = @"";
    [self.fileRecognizer startFileRecognitionWithDelegate:self];
}

- (void)recognizeFlowAction:(UIButton *)sender {
    
    int r = [self startDataRecognitionWithDelegate:self];
    if (r == 0) {
        NSLog(@"开启识别成功");
    }else {
        NSLog(@"开启识别失败");
    }
}

- (int)startDataRecognitionWithDelegate:(id<DBVoiceRecognizeDelgate>)delegate
{
    NSString *filePath = [self getPcmFilePathWithFileName:recordFileName];
    self.filePath = filePath;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return -1;
    }
    
    [self resetRecognizer];
    
    double recordDurationTime = DB_SINGLE_SENTENCE_BUFFER_DURATION_SECONDS;
    
    self.sizeToRead = self.rawDataRecognizer.sampleRate * recordDurationTime * 16 / 8;
    
    int status = [self.rawDataRecognizer startDataRecognitionWithDelegate:delegate];
    
    if (status != EVoiceRecognitionStartWorking) {
        return status;
    }
    
    NSThread *fileReadThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(fileReadThreadFunc)
                                                         object:nil];
    self.fileReadThread = fileReadThread;
    [self.fileReadThread start];
    return 0;
}


- (void)resetRecognizer
{
    self.hasReadFileSize = 0;
    if (self.fileReadThread) {
        [self.fileReadThread cancel];
        while (self.fileReadThread && ![self.fileReadThread isFinished])
        {
            [NSThread sleepForTimeInterval:0.1];
        }
    }
}

- (void)fileReadThreadFunc
{
    while ([self.fileReadThread isCancelled] == NO) {
        //间隔一定时长获取语音，模拟人的正常语速
        [NSThread sleepForTimeInterval:0.12];
        
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.filePath];
        [self.fileHandle seekToFileOffset:self.hasReadFileSize];
        NSData* data = [self.fileHandle readDataOfLength:self.sizeToRead];
        [self.fileHandle closeFile];
        self.hasReadFileSize += [data length];
        [self.rawDataRecognizer sendDataToRecognizer:data];
        if ([data length] == 0) {
            break;
        }
    }
}


//MARK: DBVoiceRecognizeDelgate

- (void)onBeginOfSpeech {
    [self appendLogMessage:@"开始语音识别"];
}


- (void)onResult:(NSArray<NSString *> *)nBest uncertain:(NSArray<NSString *> *)uncertain isLast:(BOOL)isLast {
    if (uncertain.count > 1) {
        [self showRecognizeMessag:[NSString stringWithFormat:@"nBestFisrt:%@ uncertainFirst:%@ end:%@",nBest[0],uncertain[0],@(isLast)]];
    }else {
        [self showRecognizeMessag:[NSString stringWithFormat:@"%@",nBest[0]]];

    }
}

- (void)onVolumeChanged:(NSInteger)volume data:(NSData *)data {
    [self.recordData appendData:data];
    self.pcmIndex++;
    static NSInteger count = 0;
    count++;
    if (count == 10) {
        [self appendLogMessage:[NSString stringWithFormat:@"音量:%@",@(volume)]];
        count=0;
    }
}
- (void)onEndOfSpeech {
    [self appendLogMessage:@"结束语音识别"];
    
    [self writeDataToCacheFileWithData:self.recordData fileName:recordFileName];

    [self resumeAction];
}

- (void)onError:(NSInteger)code message:(NSString *)message {
    [self appendLogMessage:[NSString stringWithFormat:@"code:%@,message:%@",@(code),message]];
    [self resumeAction];
}
// TODO: 测试代码
- (void)resumeAction {
    #ifdef DevLog
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self startRecognize];
       });
    #endif

}

// MARK: Private Methods

- (void)writeDataToCacheFileWithData:(id)data fileName:(NSString *)fileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachePaths = [NSString stringWithFormat:@"%@/data%@.pcm",path,fileName];
    [data writeToFile:cachePaths atomically:YES];
}

// 返回pcm的音频路径
-(NSString *)getPcmFilePathWithFileName:(NSString *)fileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/data%@.pcm",path,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager fileExistsAtPath:filePath];
    if (ret) {
        return filePath;
    }
    return nil;
}

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}

- (void)appendLogMessage:(NSString *)message {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakself) strongSelf = weakself;
        NSString *text = self.statusTextView.text;
        NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@:%@",[strongSelf currentFormatTime],message]];
        strongSelf.statusTextView.text = appendText;
        [strongSelf.statusTextView scrollRangeToVisible:NSMakeRange(strongSelf.statusTextView.text.length, 1)];
    });
}

- (void)showRecognizeMessag:(NSString *)message {
   __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakself) strongSelf = weakself;
//        NSString *text = strongSelf.resultTextView.text;
//        NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@:%@",[strongSelf currentFormatTime],message]];
        strongSelf.resultTextView.text = message;
        [strongSelf.resultTextView scrollRangeToVisible:NSMakeRange(strongSelf.resultTextView.text.length, 1)];
    });
}

- (NSString *)currentFormatTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc]init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    NSString *dataString = [dateFormatter stringFromDate:date];
    return dataString;
}

- (DBFileRecognizer *)fileRecognizer {
    if (!_fileRecognizer) {
        NSString *filePath = [self getPcmFilePathWithFileName:recordFileName];
        _fileRecognizer = [[DBFileRecognizer alloc]initFileRecognizerWithFilePath:filePath sampleRate:DBAudioSampleRate16K];
    }
    return _fileRecognizer;
}

-(DBRawDataRecognizer *)rawDataRecognizer {
    if (!_rawDataRecognizer) {
        _rawDataRecognizer = [[DBRawDataRecognizer alloc]initRecognizerWithSampleRate:DBAudioSampleRate16K];
    }
    return _rawDataRecognizer;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
