//
//  JDNetApiManager.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"

#import <AFNetworking/AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ServerType) {
    kSeverTypeMock,     // 模拟开发服务器地址
    kSeverTypeDev,     // 开发服务器地址
    kSeverTypeTest,     //测试服务器地址
    kSeverTypeRelease   //发布版服务器地址
};

@interface JDNetApiManager : NSObject

+ (void)configNetwork;
+ (void)configNetworkbaseUrl:(NSString*)baseUrl;
+ (void)configNetworkNormelBaseUrlWithServerType:(ServerType)serverType;
+ (void)configHttpsWithIsCert:(BOOL)isCert withCertName:(NSString*)certName;

+ (NSMutableDictionary *)getParametersWithService:(NSString *)service;

+ (void)startNetworkMonitoring;
+ (void)stopNetworkMonitoring;
+ (BOOL)isNetworkReachable;
+ (AFNetworkReachabilityStatus)getNetworkStatus;

+ (NSString *)getToken;

@end

NS_ASSUME_NONNULL_END
