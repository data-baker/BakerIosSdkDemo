//
//  DBCommonConst.h
//  DBSocketRocketKit
//
//  Created by 李明辉 on 2020/8/31.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef bb_dispatch_main_async_safe
#define bb_dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif
// 鉴权错误
typedef NS_ENUM(NSUInteger,DBErrorState) {
    DBErrorStateCodeClientId    = 2000001, // 缺少ClientId
    DBErrorStateCodeSecret      = 2000002, // 缺少Secret
    DBErrorStateCodeToken       = 2000003, // token获取失败
};
// ttsSDK错误
typedef NS_ENUM(NSUInteger,DBTTSErrorState) {
    DBErrorFailedCodeParameters  = 2010001, // 参数未设置
    DBErrorFailedCodeText        = 2010002, // 合成文本内容为空
    DBErrorFailedCodeVoiveName   = 2010003, // 发音人参数错误
    DBErrorFailedCodeResultParse = 2010004, // 解析错误
    DBErrorFailedCodeSynthesis   = 2010005, // 链接服务器失败
};
// asrSDK错误
typedef NS_ENUM(NSUInteger, DBASRErrorState){

    DBErrorNetworkUnusabel      = 2020001, // 本地网络不可用
    DBErrorNotConnectToServer   = 2020002, // 网络连接失败
    DBErrorStateSpeechShort     = 2020003, // 声音太短
    DBErrorStateNoSpeech        = 2020004, // 没有说话
    DBErrorStateSpeechUnKnown   = 2020005, // 录音出现未知错误
    DBErrorStateRecordPermission= 2020006, // 麦克风错误
    
};

@interface DBCommonConst : NSObject

+ (NSString *)currentTimeString;

@end

NS_ASSUME_NONNULL_END
