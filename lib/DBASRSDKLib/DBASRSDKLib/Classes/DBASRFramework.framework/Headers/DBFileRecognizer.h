//
//  VRFileRecognizer.h
//  VoiceRecognitionClient
//
//  Created by linxi on 16/11/16.
//  Copyright © 2019年 biaobei, Inc. All rights reserved.
//

#import "DBRawDataRecognizer.h"

@interface DBFileRecognizer : DBRawDataRecognizer

@property (nonatomic, retain) NSString *filePath;



- (id)initFileRecognizerWithFilePath:(NSString *)filePath
                          sampleRate:(DBAudioSampleRate)rate;
/**
 * @brief 发起一次文件识别
 *
 * @return 状态码，-1表示文件不存在，其余同[DIDIVoiceRecognitionClient startVoiceRecognition]
 */
- (int)startFileRecognitionWithDelegate:(id<DBVoiceRecognizeDelgate>)delegate;


@end
