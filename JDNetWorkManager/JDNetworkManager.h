//
//  JDNetworkManager.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN

@interface JDNetworkManager : NSObject

+ (void)startNetworkMonitoring;
+ (void)stopNetworkMonitoring;
+ (BOOL)isReachable;
+ (AFNetworkReachabilityStatus)getNetworkStatus;

@end

NS_ASSUME_NONNULL_END
