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

@interface JDNetApiManager : NSObject


+ (void)configNetwork;


+ (NSMutableDictionary *)getParametersWithService:(NSString *)service;

+ (void)startNetworkMonitoring;
+ (void)stopNetworkMonitoring;
+ (BOOL)isNetworkReachable;
+ (AFNetworkReachabilityStatus)getNetworkStatus;

+ (NSString *)getToken;

@end

NS_ASSUME_NONNULL_END
