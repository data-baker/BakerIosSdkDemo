//
//  PCMDataPlayer.h
//  VoicePlayDemo
//
//  Created by 小龙 on 2018/11/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCMDataPlayer : NSObject

/// 开始播放
- (void)startPlay;
/// 停止播放
- (void)stopPlay;

///回调当次buffer的数据
/// @param data 当次buffer获取到的数据
/// @param endflag 是否为最后一段数据
- (void)appendData:(NSData *)data endFlag:(BOOL)endflag;


@end

NS_ASSUME_NONNULL_END
