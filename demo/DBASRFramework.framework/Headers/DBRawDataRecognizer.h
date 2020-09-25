//
//  VRRawDataRecognizer.h
//  VoiceRecognitionClient
//
//  Created by linxi on 16/11/16.
//  Copyright © 2019年 biaobei, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBASREnumerte.h"
#import "DBASRClient.h"


@interface DBRawDataRecognizer : NSObject

@property (nonatomic) BOOL isStarted;
@property (nonatomic) DBAudioSampleRate sampleRate;


- (id)initRecognizerWithSampleRate:(DBAudioSampleRate)rate;
/**
 * @brief 开始识别
 *
 * @return 状态码，同[DIDIVoiceRecognitionClient startVoiceRecognition]
 */
- (int)startDataRecognitionWithDelegate:(id<DBVoiceRecognizeDelgate>)delegate;

/**
 * @brief 向识别器发送数据
 *
 * @param data 发送的数据
 */
- (void)sendDataToRecognizer:(NSData *)data;

@end
