//
//  DBASREnumerte.h
//  DBASRFramework
//
//  Created by linxi on 2019/12/31.
//  Copyright © 2019 biaobei. All rights reserved.
//

#ifndef DBASREnumerte_h
#define DBASREnumerte_h

#define DB_HTTP_CONTENT_TYPE_KEY                                @"Content-Type"
#define DB_HTTP_CONTENT_TYPE_CONTENT                        @"multipart/form-data; boundary="
#define DB_HTTP_CONTENT_TYPE_CONTENT_UPLOAD_WORDS           @"application/x-www-form-urlencoded;charset=utf-8"



//// 录音和预处理库
#define DB_CHANNELS_PRE_FRAME                                    1
#define DB_BIT_PRE_CHANNEL                                           16
#define DB_BYTES_PRE_PACKET                (DB_BIT_PRE_CHANNEL / 8) * DB_CHANNELS_PRE_FRAME
#define DB_MFE_COMPRESS_RATIO                                    8.0

#define DB_FRAMES_PRE_PACKET                                       1
#define DB_NUMBER_RECORD_BUFFERS                              3
#define DB_SINGLE_SENTENCE_BUFFER_DURATION_SECONDS            0.080
#define DB_MULTI_SENTENCE_BUFFER_DURATION_SECONDS                0.128
#define DB_RECORD_BUFFER_SIZE 320
#define NOTIFICATION_VOICERECOGNITION_SDK_INTRUPTION_STATUS @"voiceRecognitionSDKIntruption"
#define NOTIFICATION_VOICERECOGNITION_SDK_INTRUPTION @"voiceRecognitionSDKIntruptionStatus"
#define VR_PCM_SAMPLE_RATE_16K 16000
#define VR_PCM_SAMPLE_RATE_8K 8000

#import "DBPublicEumerte.h"




#endif /* DBASREnumerte_h */
