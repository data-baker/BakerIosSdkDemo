//
//  DBTTSEnumerate.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#ifndef DBTTSEnumerate_h
#define DBTTSEnumerate_h

typedef void(^DBMessageHandler)(BOOL ret,NSString * message);



typedef NS_ENUM(NSUInteger,DBErrorFailedCode) {
    DBErrorFailedCodeClientId    = 2000001, // 缺少ClientId
    DBErrorFailedCodeSecret      = 2000002, // 缺少Secret
    DBErrorFailedCodeToken       = 2000003, // token获取失败
    DBErrorFailedCodeParameters  = 2000004, // 参数未设置
    DBErrorFailedCodeText        = 2000005, // 合成文本内容为空
    DBErrorFailedCodeVoiveName   = 2000006, // 发音人参数错误
    DBErrorFailedCodeResultParse = 2000007, // 解析错误
    DBErrorFailedCodeSynthesis   = 2000008, // 链接服务器失败
    //**********服务端返回的错误*********//
    DBErrorFailedCodeAccessToken = 10001, // access_token参数获取失败或未传输
    DBErrorFailedCodeDomin = 10002, //domain参数值错误
    DBErrorFailedCodeLanguage =10003, //language参数错误
    DBErrorFailedCodeRate = 10006, // rate参数错误
    DBErrorFailedCodeIdx = 10007, // idx错误
    DBErrorFailedCodeSingle = 10008, // single错误
    DBErrorFailedCodeTextSever = 10009, // text参数错误
    DBErrorFailedCodeTextLong = 10010, //文本太长
    DBErrorFailedCodeGetResource = 20000, //获取资源错误
    DBErrorFailedCodeAssertText = 20001, //断句失败
    DBErrorFailedCodeSegmentTation = 20002 ,// 分段数错误
    DBErrorFailedCodeSegmentTationText = 20003, //分段后的文本长度错误
    DBErrorFailedCodeEngineLink = 20004, // 获取引擎链接错误
    DBErrorFailedCodeRPC = 20005, //RPC链接错误
    DBErrorFailedCodeEngineInner = 20006,// 引擎内部错误
    DBErrorFailedCodeRedis = 20007, // 操作redis错误
    DBErrorFailedCodeAudioEncode = 20008,// 音频编码错误
    DBErrorFailedCodeAuthor = 30000,//鉴权错误
    DBErrorFailedCodeConcurrency = 30001,// 并发错误
    DBErrorFailedCodeInnerConfigure = 30002,// 内部配置错误
    DBErrorFailedCodeParseJSON = 30003, // json串解析错误
    DBErrorFailedCodeGetUrl = 30004,// 获取url错误
    DBErrorFailedCodeGetIP = 30005,// 获取客户ip错误
    DBErrorFailedCodeTaskQueue = 30006,// 任务队列错误
    DBErrorFailedCodeJsonStruct = 40001, //请求不是json结构
    DBErrorFailedCodeLackRequireFied = 40002,// 缺少必须字段
    DBErrorFailedCodeVersion = 40003,// 版本错误
    DBErrorFailedCodeFiedType = 40004,//字段类型错误
    DBErrorFailedCodeFiedError = 40005,// 参数错误
    
    
};




#endif /* DBTTSEnumerate_h */
