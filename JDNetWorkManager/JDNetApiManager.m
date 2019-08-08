//
//  JDNetApiManager.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDNetApiManager.h"
//#import "JDNetwork.h"
#import <JDragonNetWork/JDNetwork.h>


typedef NS_ENUM(NSUInteger, ServerType) {
    kSeverTypeMock,     // 模拟开发服务器地址
    kSeverTypeDev,     // 开发服务器地址
    kSeverTypeTest,     //测试服务器地址
    kSeverTypeRelease   //发布版服务器地址
};
@implementation JDNetApiManager


+ (void)configNetwork {
    //    JDNetworkAgent *agent = [JDNetworkAgent sharedAgent];
    //    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencodem", nil] forKeyPath:@"_manager.responseSerializer.acceptableContentTypes"];
#ifdef DEBUG
    static ServerType serverType = 2;
#else
    static ServerType serverType = 3;
#endif
    JDNetworkConfig *config = [JDNetworkConfig sharedConfig];
    config.debugLogEnabled = YES; // 总开关
    config.developerLogEnabled = YES;
    config.logHeaderInfoEnabled = YES;
    config.logResponseObjectEnabled = NO;
    config.logResponseStringEnabled = YES;
    config.logCacheMetaDataEnabled = NO;
    config.logCookieEnabled = NO;
    config.logRestfulEnabled = NO;
    //    config.securityPolicy = [self defaultSecurityPolicyByAF];
    switch (serverType) {
        case kSeverTypeMock:     // 开发服务器地址
            config.baseUrl = @"";
            break;
        case kSeverTypeDev:     // 开发服务器地址
            config.baseUrl = @"";
            break;
        case kSeverTypeTest:     // 测试服务器地址
            config.baseUrl = @"";
            break;
        case kSeverTypeRelease:   // 发布版服务器地址
            config.baseUrl = @"";
            break;
        default:
            break;
    }
    //证书配置 是需要双向验证
    //    [self configHttpsWithIsCert:NO];
}
+ (void)configHttpsWithIsCert:(BOOL)isCert {
    
    // 获取证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ssl_content" ofType:@"pem"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // 配置安全模式
    JDNetworkConfig *config = [JDNetworkConfig sharedConfig];
    //    config.cdnUrl = @"";
    
    // 验证公钥和证书的其他信息
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:isCert?AFSSLPinningModeCertificate:AFSSLPinningModeNone];
    
    // 允许自建证书
    securityPolicy.allowInvalidCertificates = isCert;
    
    // 校验域名信息
    securityPolicy.validatesDomainName = isCert;
    
    // 添加服务器证书,单向验证;  可采用双证书 双向验证;
    //    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    [config setSecurityPolicy:securityPolicy];
}

//const static NSString *AppApiVersion = @"Appv1";
//+ (NSMutableDictionary *)getParametersWithService:(NSString *)service {
//    if (service == nil) service = @"";
//#if DEBUG
//    // 接口版本控制
//    NSArray *array = [service componentsSeparatedByString:@"."];
//    NSMutableArray *serviceArray = [NSMutableArray arrayWithCapacity:array.count];
//    [serviceArray addObject:AppApiVersion];
//    for (int i=1; i<array.count; i++) {
//        [serviceArray addObject:array[i]];
//    }
//    service = [serviceArray componentsJoinedByString:@"."];
//#else
//    NSArray *array = [service componentsSeparatedByString:@"."];
//    NSMutableArray *serviceArray = [NSMutableArray arrayWithCapacity:array.count];
//    [serviceArray addObject:AppApiVersion];
//    for (int i=1; i<array.count; i++) {
//        [serviceArray addObject:array[i]];
//    }
//    service = [serviceArray componentsJoinedByString:@"."];
//#endif
//
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:service forKey:@"service"];
//
//    return dic;
//}

+ (void)startNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isNetworkReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
+ (AFNetworkReachabilityStatus)getNetworkStatus {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}
+ (NSString *)getToken {
    
    return @"";
}

@end
