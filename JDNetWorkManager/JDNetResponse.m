//
//  JDNetResponse.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDNetResponse.h"
#import "JDNetRequest.h"

@implementation JDNetResponse

+ (instancetype)responseWithRequest:(JDNetRequest *)request {
    if (!request) return nil;
    JDNetResponse *response = (JDNetResponse*)[[[self  class] alloc]init];
    [response updateServerStatusCodesWithRequest:request];
    [response updateRequestResponseStatusCodeWithRequest:request];
    response.responseObject = [self responseObjectValidator:request.responseObject];
    return response;
}
+ (id)responseObjectValidator:(id)responseObject {
   
    return responseObject;
}
+ (instancetype)responseWithCacheRequest:(JDNetRequest *)request
{
    if (!request) return nil;
    JDNetResponse *response = (JDNetResponse*)[[[self  class] alloc]init];
    if ([request loadCacheWithError:nil]) {
         NSLog(@"使用缓存数据");
        response.responseObject = [request responseJSONObject];
    }
    response.success = true;
    response.serverResponseStatusCode = 200;
    response.responseStatusType = JDNetResponseStatusTypeSuccess;
    return response;
}
- (void)updateServerStatusCodesWithRequest:(JDNetRequest *)request {
    NSInteger statusCode = [request responseStatusCode];
    self.serverResponseStatusCode = statusCode;
    if (statusCode > 200 && statusCode < 300) {
        self.responseStatusType = JDNetResponseStatusTypeRequestError;
    }
    else {
        if (self.serverResponseStatusCode == 1) { // 没有网络
            self.responseStatusType = JDNetResponseStatusTypeNoNetwork;
            return;
        }
        
        if (self.serverResponseStatusCode == 200) {
            self.responseStatusType = JDNetResponseStatusTypeSuccess;
            self.success = true;
            return;
        }
        if (self.serverResponseStatusCode == 400) {
            self.responseStatusType = JDNetResponseStatusTypeRequestError;
            return;
        }
        if (self.serverResponseStatusCode > 400 && self.serverResponseStatusCode < 500) {
            self.responseStatusType = JDNetResponseStatusTypeExpiryToken;
            return;
        }
        
        if (self.serverResponseStatusCode == 500) {
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (self.serverResponseStatusCode == 501) {
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (self.serverResponseStatusCode == 502) {
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (self.serverResponseStatusCode == 600) {
            self.responseStatusType = JDNetResponseStatusTypeNotLogin;
            return;
        }
    }
}
- (void)updateRequestResponseStatusCodeWithRequest:(JDNetRequest *)request {

    self.requestResponseStatusCode = 0;
}
- (BOOL)alertOrNot {
    if (!(self.responseStatusType == JDNetResponseStatusTypeNoNetwork ||
          self.responseStatusType == JDNetResponseStatusTypeExpiryToken ||
          self.responseStatusType == JDNetResponseStatusTypeDataNull)) {
        return YES;
    }
    
    return NO;
}

// 是否没有有网络
- (BOOL)isNoNetwork {
    if (self.responseStatusType == JDNetResponseStatusTypeNoNetwork) {
        return YES;
    }
    
    return NO;
}

// 是否token失效
- (BOOL)isExpiryToken {
    if (self.responseStatusType == JDNetResponseStatusTypeExpiryToken) {
        return YES;
    }
    
    return NO;
}

// 服务器错误
- (BOOL)isRequestServerError {
    if (self.responseStatusType == JDNetResponseStatusTypeRequestError) {
        return YES;
    }
    
    return NO;
}

// 后台服务错误
- (BOOL)isServerServiceError {
    if (self.responseStatusType == JDNetResponseStatusTypeServerServiceError) {
        return YES;
    }
    
    return NO;
}

// 该目标已存在
- (BOOL)isTargetExist {
    return NO;
}

@end
