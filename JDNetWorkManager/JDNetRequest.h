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
#import "JDNetResponse.h"

NS_ASSUME_NONNULL_BEGIN

@class JDNetRequest;

typedef void(^JDNetRequestCompletionBlock)(id request);
typedef void(^JDNetBatchRequestCompletionBlock)(JDBatchRequest *request);

@interface JDNetRequest : JDRequest



@property (nonatomic,  copy)  NSString *JDRequestUrl;
@property (nonatomic, strong) JDNetResponse *JDResponse;


/// 请求 只成功回调
/// @param url 请求url
/// @param Arguments 参数
/// @param success 成功回调
+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success;


/// 请求带error 回调
/// @param url 请求url
/// @param Arguments 参数
/// @param success 成功回调
/// @param failure 失败回调
+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success
                           failure:(JDNetRequestCompletionBlock)failure;


/// 串行请求
/// @param urls 请求url 数组
/// @param argumentsArr 参数数组
/// @param delegate 代理回调
+(JDChainRequest*)startChainRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
                        withRequestDelegate:(id<JDChainRequestDelegate>)delegate;


/// 并行请求
/// @param urls 请求url 数组
/// @param argumentsArr 参数数组
/// @param success 成功回调
/// @param failure 失败回调
+(JDBatchRequest*)startBatchRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
             withCompletionBlockWithSuccess:(JDNetBatchRequestCompletionBlock)success
                                    failure:(JDNetBatchRequestCompletionBlock)failure;


+(NSDictionary*)publicHead;

@end

NS_ASSUME_NONNULL_END
