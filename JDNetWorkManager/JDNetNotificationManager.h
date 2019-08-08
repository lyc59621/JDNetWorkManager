//
//  JDNetNotificationManager.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern const NSString *kNotNetworkNotificationKey;

@interface JDNetNotificationManager : NSObject

// 无网络
+ (void)postNoNetworkNotification:(NSDictionary *)userInfo;

// 无网络
+ (void)addNoNetworkBoserver:(id)target selector:(SEL)selector;

+ (void)removeObservers:(id)target;

@end

NS_ASSUME_NONNULL_END
