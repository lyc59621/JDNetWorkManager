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


//@property (nonatomic, strong) NSDictionary *filtResponseObj;

@property (nonatomic,  copy) NSString *JDRequestUrl;

@property (nonatomic, strong) JDNetResponse *JDResponse;


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
