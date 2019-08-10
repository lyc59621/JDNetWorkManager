//
//  JDUploadRequest.h
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDNetRequest.h"

NS_ASSUME_NONNULL_BEGIN

// 上传图片返回的模型
@interface JDUploadResponseModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *file;

@property (nonatomic, copy) NSString *file_name;

@end

@interface JDUploadRequest : JDNetRequest

//@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock uploadProgressBlock;


/**
 不带参数上传头像

 @param url <#url description#>
 @param name <#name description#>
 @param images <#images description#>
 @param progress <#progress description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(instancetype)startRequestWithUrl:(NSString*)url
                          withName:(NSString*)name
                        withImages:(NSArray*)images
                 withProgressBlock:(AFURLSessionTaskProgressBlock)progress
    withCompletionBlockWithSuccess:(JDRequestCompletionBlock)success
                           failure:(JDRequestCompletionBlock)failure;

/**
 带参数上传头像

 @param url <#url description#>
 @param name <#name description#>
 @param images <#images description#>
 @param arguments NSDictionary description
 @param progress <#progress description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(instancetype)startRequestWithUrl:(NSString*)url
                          withName:(NSString*)name
                        withImages:(NSArray*)images
                     withArguments:(NSDictionary*)arguments
                 withProgressBlock:(AFURLSessionTaskProgressBlock)progress
    withCompletionBlockWithSuccess:(JDRequestCompletionBlock)success
                           failure:(JDRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
