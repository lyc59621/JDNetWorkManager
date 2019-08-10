//
//  JDNetRequest.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <JDragonNetWork/JDNetwork.h>
#import "JDNetApiManager.h"
#import "JDNetNotificationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class JDNetRequest;

typedef void(^JDNetRequestCompletionBlock)( JDNetRequest *request);
typedef void(^JDNetBatchRequestCompletionBlock)( JDBatchRequest *request);

@interface JDNetRequest : JDRequest


//HTTP返回接口状态码，其中：200 成功，
//                  600 未登录
//                  500 服务器错误
//                  501 已经存在
//                  502 数据接口为空
//                  400 请求参数有错，
//                  401 非法请求，
//                  1 没有网络
//                  0 服务后台问题，可使用response的statuscode查询具体问题

@property (nonatomic, readonly, assign) NSInteger serverResponseStatusCode;

//返回请求状态码，其中：0正常，其他不正常
@property (nonatomic, readonly, assign) NSInteger serverRequestStatusCode;


@property (nonatomic, strong) NSDictionary *filtResponseObj;

// 返回的提示信息
@property (nonatomic, readonly, copy) NSString *serverResponseMessage;

@property (nonatomic,  copy) NSString *JDRequestUrl;

+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success;

+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success
                           failure:(JDNetRequestCompletionBlock)failure;

+(JDChainRequest*)startChainRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
                        withRequestDelegate:(id<JDChainRequestDelegate>)delegate;

+(JDBatchRequest*)startBatchRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
             withCompletionBlockWithSuccess:(JDNetBatchRequestCompletionBlock)success
                                    failure:(JDNetBatchRequestCompletionBlock)failure;

//+ (RACSignal *)rac_requestSignalWithUrl:(NSString*)url withExtendArguments:(NSDictionary*)Arguments;


+(NSDictionary*)publicHead;

@end

NS_ASSUME_NONNULL_END
