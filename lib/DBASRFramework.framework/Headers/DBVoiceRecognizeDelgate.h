//
//  DBRecognitionDeleate.h
//  DBASRDemo
//
//  Created by 李明辉 on 2020/9/17.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// @protocol - MVoiceRecognitionClientDelegate
// @brief - 语音识别工作状态通知
@protocol DBVoiceRecognizeDelgate<NSObject>
@optional
// MARK: 语音识别的接口

/// 返回音量大小
/// @param volume 音量大小
/// @param data 音频数据
- (void)onVolumeChanged:(NSInteger)volume data:(NSData *)data;

/// 识别 结果
/// @param nBest 识别到的最好的结果
/// @param uncertain 识别到的不确定的结果
/// @param isLast 是否是最后的识别结果
- (void)onResult:(NSArray<NSString *> *)nBest uncertain:(NSArray<NSString *> *)uncertain isLast:(BOOL)isLast;

/// 此回调表示，sdk内部录音机已经准备好了，用户可以开始语音输入
- (void)onBeginOfSpeech;

/// 此回调表示，检测到语音的尾断点，已经进入识别过程，不再接受语音输入
- (void)onEndOfSpeech;

/// 识别发生错误
/// @param code 错误码
/// @param message 错误信息，格式traceId + sid
- (void)onError:(NSInteger)code message:(NSString *)message;


@end

NS_ASSUME_NONNULL_END
