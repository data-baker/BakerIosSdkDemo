//
//  DBRecognitionManager.h
//  DBASRDemo
//
//  Created by 李明辉 on 2020/9/17.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBVoiceRecognizeDelgate.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DBMessageHandler)(BOOL ret,NSString * message);


@interface DBRecognitionManager : NSObject

///超时时间,默认30s
@property(nonatomic,assign)NSInteger  timeOut;

/// 1.打印日志 0:不打印日志
@property(nonatomic,assign,getter = isLog)BOOL log;
// --类方法
+ (DBRecognitionManager *)sharedInstance;

// 初始化SDK的clientId，和clientSecret
- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret failureHandler:(DBMessageHandler)handler;


// 私有化部署时不需要设置clientId和clientSecret,直接设置url即可
- (void)setupPrivateDeploymentURL:(NSString *)url;

/// 开始识别
- (int)startVoiceRecognition:(id<DBVoiceRecognizeDelgate>)delegate;

/// 结束识别
- (void)stopVoiceRecognition;

///TODO:  设置录音的采样率，默认为16k,目前仅支持16K
///- (void)setSampleRate:(DBAudioSampleRate)rate;

/// 获取设置的采样率
- (int)getCurrentSampleRate;



@end

NS_ASSUME_NONNULL_END
