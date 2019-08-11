//
//  JDNetRequest.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDNetRequest.h"

NSString *const JDNetUrl_Version = @"";

typedef NS_ENUM(NSInteger,JDNetRefreshCacheTimeType)
{
    JDNetRequestCacheTimeTypeNone=1,
    JDNetRequestCacheTimeTypeShort=2,
    JDNetRequestCacheTimeTypeLong=3,
    JDNetRequestCacheTimeTypeFirstLong=4
    
};

@interface JDNetRequest ()


@property (nonatomic, assign)JDNetRefreshCacheTimeType cacheTimeType;
@property (nonatomic, readwrite, assign) NSInteger serverResponseStatusCode;
@property (nonatomic, readwrite, assign) NSInteger serverRequestStatusCode;
@property (nonatomic, readwrite, copy) NSString *serverResponseMessage;

@property (nonatomic, strong) NSDictionary *argument;
@property (nonatomic, assign) NSInteger firstCacheTime;

@end


@implementation JDNetRequest


-(id)init
{
    self=[super init];
    if (self) {
        self.cacheTimeType=JDNetRequestCacheTimeTypeFirstLong;
        self.ignoreCache = true;
    }
    return self;
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10.0;
}
-(NSInteger)cacheTimeInSeconds
{
    NSInteger seconds=-1;
    switch (_cacheTimeType) {
            case JDNetRequestCacheTimeTypeFirstLong:
            seconds= 60*60*24*30;
            break;
            case JDNetRequestCacheTimeTypeLong:
            seconds=10*6;
            break;
            case JDNetRequestCacheTimeTypeShort:
            seconds= 5;
            break;
            case JDNetRequestCacheTimeTypeNone:
        default:
            break;
    }
    return seconds;
}
- (JDRequestMethod)requestMethod {
    //#ifdef DEBUG
    //    return ECRequestMethodGET;
    //#else
    //    return ECRequestMethodPOST;
    //#endif
    return JDRequestMethodPOST;
}
- (id)requestArgument
{
    return self.argument;
}
-(NSString*)requestUrl
{
    return @"";
}
// 如果没有网络 failure同步方式返回
- (void)startWithCompletionBlockWithSuccess:(JDRequestCompletionBlock)success
                                    failure:(JDRequestCompletionBlock)failure {
    if (![JDNetApiManager isNetworkReachable]) {
        [JDNetNotificationManager postNoNetworkNotification:@{}];
        if (failure)
        {
            failure(self);
        }
        return;
    }
    [self setCompletionBlockWithSuccess:success failure:^(__kindof JDNetRequest * _Nonnull request) {
        if (failure)
        {
            failure(request);
        }
#if DEBUG
        if (!request.responseObject)
        NSLog(@"解析失败");
#endif
    }];
    [self start];
}
+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success
{
    return  [JDNetRequest startRequestWithUrl:url withExtendArguments:Arguments withCompletionBlockWithSuccess:success failure:^(__kindof JDNetRequest * _Nonnull request) {
        
    }];
}

+(instancetype)startRequestWithUrl:(NSString*)url
               withExtendArguments:(NSDictionary*)Arguments
    withCompletionBlockWithSuccess:(JDNetRequestCompletionBlock)success
                           failure:(JDNetRequestCompletionBlock)failure
{
    JDNetRequest  *req  = [[JDNetRequest  alloc]init];
    [req setJDRequestUrl:url];
    NSMutableDictionary  *dic = [[NSMutableDictionary  alloc]initWithDictionary:Arguments];
    req.argument = dic;
    [req isShowHUDConfig];
    [req setCompletionBlockWithSuccess:^(__kindof JDNetRequest * _Nonnull request) {
        NSLog(@"请求成功%@",request.filtResponseObj);
        if([request.filtResponseObj isKindOfClass:[NSNull class]])return;
        success(request);
    } failure:^(__kindof JDBaseRequest * _Nonnull request) {
        NSString  *error = request.error.localizedDescription;
        if (req.serverResponseMessage.length>0) {
            error = req.serverResponseMessage;
        }
        NSLog(@"返回数据==%@ error==%@",request.responseObject,error);
        if (failure) {
            failure(request);
        }
        [request statusCodeValidator];
    }];
    [req start];
    return req;
}
+(JDChainRequest*)startChainRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
                        withRequestDelegate:(id<JDChainRequestDelegate>)delegate
{
    JDChainRequest *chainRequest = [[JDChainRequest alloc] init];
    NSMutableArray  *requestArr = [[NSMutableArray alloc]init];
    for (int i=0; i<urls.count; i++) {
        
        JDNetRequest  *req  = [[JDNetRequest  alloc]init];
        [req setJDRequestUrl:urls[i]];
        NSMutableDictionary  *dic = [[NSMutableDictionary  alloc]initWithDictionary:argumentsArr[i]];
        req.argument = dic;
        [requestArr addObject:req];
        //        if ([req loadCacheWithError:nil]) {
        //             NSDictionary *json = [req responseJSONObject];
        //             DDLogVerbose(@"使用缓存数据");
        //             req.filtResponseObj = json[@"data"];
        //                    // show cached data
        //        }
    }
    __block NSInteger  i = 0;
    [chainRequest addRequest:requestArr[i] callback:^(JDChainRequest * _Nonnull chainRequest, JDBaseRequest * _Nonnull baseRequest) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"*%@请求完成 \n**进入下一个请求%@",NSStringFromClass([baseRequest class]),NSStringFromClass([requestArr[i] class])]);
        if (i<requestArr.count-1) {
            [chainRequest addRequest:requestArr[i+1] callback:nil];
        }
        i+=1;
    }];
    chainRequest.delegate = delegate;
    return chainRequest;
}
//并行请求
+(JDBatchRequest*)startBatchRequestWithUrls:(NSArray*)urls
                           withArgumentsArr:(NSArray<NSDictionary*>*)argumentsArr
             withCompletionBlockWithSuccess:(JDNetBatchRequestCompletionBlock)success
                                    failure:(JDNetBatchRequestCompletionBlock)failure
{
    NSMutableArray  *requestArr = [[NSMutableArray alloc]init];
    for (int i=0; i<urls.count; i++) {
        
        JDNetRequest  *req  = [[JDNetRequest  alloc]init];
        [req setJDRequestUrl:urls[i]];
        NSMutableDictionary  *dic = [[NSMutableDictionary  alloc]initWithDictionary:argumentsArr[i]];
        req.argument = dic;
        [requestArr addObject:req];
        //        if ([req loadCacheWithError:nil]) {
        //             NSDictionary *json = [req responseJSONObject];
        //             DDLogVerbose(@"使用缓存数据");
        //             req.filtResponseObj = json[@"data"];
        //                // show cached data
        //        }
    }
    JDBatchRequest *batch = [[JDBatchRequest alloc]initWithRequestArray:requestArr];
    
    [batch startWithCompletionBlockWithSuccess:^(JDBatchRequest * _Nonnull batchRequest) {
        NSLog(@"所有请求完成");
        if (success) {
            success(batchRequest);
        }
        for (JDNetRequest *request in batchRequest.requestArray) {
            
            if (request.responseObject) {
                
                NSLog(@"请求成功%@",request.filtResponseObj);
            }
        }
    } failure:^(JDBatchRequest * _Nonnull batchRequest) {
        JDNetRequest *request = (JDNetRequest*)batchRequest.failedRequest;
        NSLog(@"%@",[NSString stringWithFormat:@"\n**原请求队列: %@。\n请求失败的接口：%@ , 错误是：%@",batchRequest.requestArray,request.requestUrl,request.responseString]);
        [request statusCodeValidator];
        if (failure) {
            failure(batchRequest);
        }
    }];
    return batch;
}
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return [[self class] publicHead];;
}
+(NSDictionary*)publicHead
{
    return @{};
}
- (BOOL)statusCodeValidator {
    
    BOOL isOk = [super statusCodeValidator];
    if (!isOk)//HTTP 错误
    {
        [self showHTTPServerResponseMessageError];
    }
    return isOk;
}
-(void)showHTTPServerResponseMessageError
{
    
    NSDictionary *reObj = self.responseObject;
    NSString  *error =[NSString stringWithFormat:@"错误code:%ld",self.responseStatusCode];
    if ([reObj.allKeys containsObject:@"error"]) {
        error = [NSString stringWithFormat:@"错误code:%ld  错误信息:%@",self.responseStatusCode,reObj[@"error"]];
    }
    [self.class errorAlertInfo:error];
}
-(void)showServerResponseMessageError
{
    if([self.serverResponseMessage isKindOfClass:[NSNull class]]|| self.serverResponseMessage.length<=0)
    {
        [self.class errorAlertInfo:@"msg返回为空"];
    }else
    {
        [self.class errorAlertInfo:self.serverResponseMessage];
    }
}
-(void)loginStateChangeAction
{
    
}
+ (void)errorAlertInfo:(NSString *)title {
    
    
}
-(void)isShowHUDConfig
{
    
}

//- (NSString *)description
//{
//    DDLogError(@"header==%@",self.currentRequest.allHTTPHeaderFields);
//
//    return [super description];
//}


@end

