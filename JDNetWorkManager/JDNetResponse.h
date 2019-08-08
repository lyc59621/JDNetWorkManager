//
//  JDNetResponse.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JDNetResponseStatusType) {
    JDNetResponseStatusTypeRequestError = 0, // 服务后台问题
    JDNetResponseStatusTypeNoNetwork = 1, // 没有网络
    JDNetResponseStatusTypeSuccess = 200,
    JDNetResponseStatusTypeExpiryToken = 401,
    JDNetResponseStatusTypeServerServiceError = 500,
    JDNetResponseStatustypeServiceExist = 501,
    JDNetResponseStatusTypeDataNull = 502,
    JDNetResponseStatusTypeNotLogin = 600,
};

@class JDNetRequest;

@interface JDNetResponse : NSObject

@property (nonatomic, assign) BOOL success;
//返回接口状态码，其中：200 成功，
//                  600 未登录
//                  500 服务器错误
//                  501 已经存在
//                  502 数据接口为空
//                  400 请求参数有错，
//                  401 非法请求，
//                  1 没有网络
//                  0 服务后台问题，可使用response的statuscode查询具体问题
@property (nonatomic, assign) JDNetResponseStatusType responseStatusType;
@property (nonatomic, assign) NSInteger serverResponseStatusCode; // 服务端返回的status code
@property (nonatomic, assign) NSInteger requestResponseStatusCode; // 请求返回的status code

@property (nonatomic, strong) id responseObject;

@property (nonatomic, copy) NSString *responseMessage;

+ (JDNetResponse *)responseWithRequest:(JDNetRequest *)request;

- (void)updateStatusCodesWithRequest:(JDNetRequest *)request;

// 是否需要提示
- (BOOL)alertOrNot;
// 是否没有有网络
- (BOOL)isNoNetwork;

// 是否token失效
- (BOOL)isExpiryToken;

// 服务器错误
- (BOOL)isRequestServerError;

// 后台服务错误
- (BOOL)isServerServiceError;

// 该目标已存在
- (BOOL)isTargetExist;

@end

NS_ASSUME_NONNULL_END
