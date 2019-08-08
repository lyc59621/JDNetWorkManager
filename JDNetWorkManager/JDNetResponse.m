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

+ (JDNetResponse *)responseWithRequest:(JDNetRequest *)request {
    if (!request) return nil;
    JDNetResponse *response = [JDNetResponse new];
    [response updateStatusCodesWithRequest:request];
    
    return response;
}

- (void)updateStatusCodesWithRequest:(JDNetRequest *)request {
    NSInteger statusCode = [request responseStatusCode];
    self.requestResponseStatusCode = statusCode;
    self.responseMessage = @"服务器错误";
    
    if (statusCode > 200 && statusCode < 300) {
        self.responseStatusType = JDNetResponseStatusTypeRequestError;
    }
    else {
        self.serverResponseStatusCode = request.serverResponseStatusCode;
        if (request.serverResponseStatusCode != 0) { // 后台服务错误
            if (request.serverResponseMessage.length) {
                self.responseMessage = request.serverResponseMessage;
            }
            self.responseStatusType = JDNetResponseStatusTypeRequestError;
            return;
        }
        
        if (request.serverResponseStatusCode == 1) { // 没有网络
            self.responseMessage = @"没有网络";
            self.responseStatusType = JDNetResponseStatusTypeNoNetwork;
            return;
        }
        
        self.responseMessage = request.serverResponseMessage;
        if (request.serverResponseStatusCode == 200) {
            self.responseMessage = request.serverResponseMessage;
            self.responseStatusType = JDNetResponseStatusTypeSuccess;
            return;
        }
        if (request.serverResponseStatusCode == 400) {
            self.responseStatusType = JDNetResponseStatusTypeRequestError;
            return;
        }
        if (request.serverResponseStatusCode > 400 && request.serverResponseStatusCode < 500) {
            //            self.responseMessage = @"token 失效";
            self.responseStatusType = JDNetResponseStatusTypeExpiryToken;
            
            return;
        }
        
        if (request.serverResponseStatusCode == 500) {
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (request.serverResponseStatusCode == 501) {
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (request.serverResponseStatusCode == 502) {
            //            self.responseStatusType = kResponseStatusTypeDataNull;
            self.responseStatusType = JDNetResponseStatusTypeServerServiceError;
            return;
        }
        
        if (request.serverResponseStatusCode == 600) {
            self.responseStatusType = JDNetResponseStatusTypeNotLogin;
            return;
        }
    }
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
