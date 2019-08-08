//
//  JDNetNotificationManager.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDNetNotificationManager.h"

const NSString *kNotNetworkNotificationKey = @"com.JD.NoNetwork";


@implementation JDNetNotificationManager

+ (void)postNoNetworkNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotNetworkNotificationKey object:nil userInfo:userInfo];
}


// 无网络
+ (void)addNoNetworkBoserver:(id)target selector:(SEL)selector {
    if (target) {
        [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:(NSString *)kNotNetworkNotificationKey object:nil];
    }
}

+ (void)removeObservers:(id)target {
    [[NSNotificationCenter defaultCenter] removeObserver:target];
}

@end
