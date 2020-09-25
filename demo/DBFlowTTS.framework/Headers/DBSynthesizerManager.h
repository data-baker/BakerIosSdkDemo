//
//  DBSocketManager.h
//  DBTTSScocketSDK
//
//  Created by linxi on 2019/11/13.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSynthesizerRequestParam.h"
#import "DBFailureModel.h"
#import "DBSynthesizerManagerDelegate.h"
@class DBSynthesisPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface DBSynthesizerManager : NSObject

@property(nonatomic,weak)id <DBSynthesizerManagerDelegate> delegate;

///超时时间,默认15s
@property(nonatomic,assign)NSInteger  timeOut;

@property(nonatomic,strong)DBSynthesisPlayer * synthesisDataPlayer;

/// 1:打印日志 0：不打印日志,默认不打印日志
@property(nonatomic,assign,getter=islog)BOOL log;

@property(nonatomic,copy)NSString * ttsSdkVersion;

/// 指定初始化方法，每次调用该方法会生成一个新的合成对象,不是单例
+ (DBSynthesizerManager *)instance;

/// 鉴权方法
- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret handler:(DBMessageHandler)handler;

// 近针对私有化授权的服务使用，调用此方法后无需设置clientIf和clientSecret
- (void)setupPrivateDeploymentURL:(NSString *)url;
/**
 * @brief 设置SynthesizerRequestParam对象参数,返回值为0,表示设置参数成功
 */
-(NSInteger)setSynthesizerParams:(DBSynthesizerRequestParam *)requestParam;

/// 开始合成
- (void)start;
///  停止合成
- (void)stop;


@end



NS_ASSUME_NONNULL_END
