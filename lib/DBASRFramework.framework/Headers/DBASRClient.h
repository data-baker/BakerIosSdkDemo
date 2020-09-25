//
//  DBASRClient.h
//  DBASRFramework
//
//  Created by linxi on 2019/12/31.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBPublicEumerte.h"
#import "DBVoiceRecognizeDelgate.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DBMessageHandler)(BOOL ret,NSString * message);

@interface DBASRClient : NSObject

///超时时间,默认30s
@property(nonatomic,assign)NSInteger  timeOut;

/// 1.打印日志 0:不打印日志
@property(nonatomic,assign,getter = isLog)BOOL log;
// --类方法
+ (DBASRClient *)sharedInstance;

// 初始化SDK的clientId，和clientSecret
- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret failureHandler:(DBMessageHandler)handler;


// 私有化部署时不需要设置clientId和clientSecret,直接设置url即可
- (void)setupPrivateDeploymentURL:(NSString *)url;

/// 开始录音
- (int)startVoiceRecognition:(id<DBVoiceRecognizeDelgate>)delegate;

/// 结束录音
- (void)stopVoiceRecognition;

/// 获取设置的采样率
- (int)getCurrentSampleRate;

/// 这个方法不要直接调用，它是提供给文件读写识别用的
- (int)startFileVoiceRecognition:(id<DBVoiceRecognizeDelgate>)delegate;


/*
 key:
 add_pct,1：添加表0：不带标点，默认不带标点；
 enable_itn,1:支持ITN，0：不支持ITN
 */
//- (void)setParamsKey:(NSString *)paramsKey paramsValue:(NSNumber *)paramsValue;



@end

NS_ASSUME_NONNULL_END
