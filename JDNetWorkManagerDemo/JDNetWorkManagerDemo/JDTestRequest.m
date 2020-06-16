//
//  JDTestRequest.m
//  JDNetWorkManagerDemo
//
//  Created by 姜锦龙 on 2020/6/16.
//  Copyright © 2020 JDragon. All rights reserved.
//

#import "JDTestRequest.h"

@implementation JDTestRequest



- (JDRequestMethod)requestMethod {
    return JDRequestMethodGET;
}
-(NSInteger)cacheTimeType
{
    return 2;
}

@end
