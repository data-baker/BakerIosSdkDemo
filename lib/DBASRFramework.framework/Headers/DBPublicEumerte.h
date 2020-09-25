//
//  DBPublicEumerte.h
//  DBASRFramework
//
//  Created by linxi on 2020/2/12.
//  Copyright © 2020 biaobei. All rights reserved.
//

#ifndef DBPublicEumerte_h
#define DBPublicEumerte_h

// 枚举 - 语音识别状态
typedef NS_ENUM (NSUInteger,DBVoiceRecognitionClientStatus){
    DBVoiceRecognitionClientStatusNone = 0,                  // 空闲
    DBVoiceRecognitionClientStatusStartWorking,           // 1 识别工作开始，开始采集及处理数据
    DBVoiceRecognitionClientStatusStart,                  // 2 检测到用户开始说话
    DBVoiceRecognitionClientStatusSentenceEnd,            // 3 输入模式下检测到语音说话完成
    DBVoiceRecognitionClientStatusEnd,                    // 4 本地声音采集结束结束，等待识别结果返回并结束录音
    DBVoiceRecognitionClientStatusNewRecordData,          // 5 录音数据回调
    DBVoiceRecognitionClientStatusReceiveData,            // 6 输入模式下有识别结果返回
    DBVoiceRecognitionClientStatusFinish,                 // 7 语音识别功能完成，服务器返回正确结果
    DBVoiceRecognitionClientStatusCancel,                 // 8 用户取消
    DBVoiceRecognitionClientStatusError,                  // 9 发生错误，详情见VoiceRecognitionClientErrorStatus接口通知
};

enum TVoiceRecognitionStartWorkResult
{
    EVoiceRecognitionStartWorking = 500,                    // 开始工作
};


typedef NS_ENUM (NSUInteger,DBNetwokingState) {
    DBNetwokingStateConnected=1000, // 已经建立网络连接
    DBNetwokingStateClosed, // 网络连接关闭
    DBNetwokingStateFailed, // 网络连接失败
    DBNetwokingStateUnknowed //网络连接状态未知
};


// 设置采样率
typedef NS_ENUM(NSUInteger, DBAudioSampleRate){
    DBAudioSampleRate16K=16000, // 16k的采样率
    DBAudioSampleRate8K=8000, // 8K的采样率
};



typedef NS_ENUM(NSUInteger, DBASRiOSErrorState){
    DBErrorStateVADInit         = 3020001, // VAD初始化错误
    DBErrorStateVADend          = 3020002, // vad关闭错误
};

typedef NS_ENUM(NSUInteger,DBRecognizeType) {
    DBRecognizeTypeVoice = 0,  // 语音识别
    DBRecognizeTypeFile,       // 文件识别
};

#endif /* DBPublicEumerte_h */
