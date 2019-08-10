//
//  JDUploadRequest.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDUploadRequest.h"
#import "JDNetwork.h"
#import "AFNetworking.h"
@implementation JDUploadResponseModel


@end


@interface JDUploadRequest ()

@property (nonatomic, copy) NSString *uploadName;
@property (nonatomic, copy) NSArray *images;

@end

@implementation JDUploadRequest

- (JDRequestMethod)requestMethod {
    return JDRequestMethodPOST;
}
//设置上传图片 所需要的 HTTP HEADER
- (AFConstructingBlock)constructingBodyBlock {
     __weak __typeof(&*self)weakSelf = self;
    return ^(id<AFMultipartFormData> formData) {

        for (int i = 0; i<weakSelf.images.count; i++) {
            
            UIImage *image = weakSelf.images[i];
            
            if ([image isKindOfClass:[UIImage class]]) {
                
                NSData *data = UIImageJPEGRepresentation(image, 1);
                if (data) {
                    NSString *fileName = [NSString stringWithFormat:@"JD_image_%@_%@.jpg",weakSelf.uploadName,[JDUploadRequest nowTimestamp]];
                    NSString *type = @"image/png/jpeg";
                    [formData appendPartWithFileData:data name:weakSelf.uploadName fileName:fileName mimeType:type];
                }
            }else
            if ([image isMemberOfClass:[NSURL class]]) {
                
                NSURL  *url = (NSURL*)image;
                NSString *fileName = [NSString stringWithFormat:@"JD_video_%@_%@.mp4",weakSelf.uploadName,[JDUploadRequest nowTimestamp]];
                NSData *videoData = [NSData dataWithContentsOfURL:url];
                NSString *type = @"video/quicktime";
                if (videoData) {
                    
                    [formData appendPartWithFileData:videoData name:weakSelf.uploadName fileName:fileName mimeType:type];
                }
            }
        }
    };
}
+(instancetype)startRequestWithUrl:(NSString*)url
                          withName:(NSString*)name
                        withImages:(NSArray*)images
                 withProgressBlock:(AFURLSessionTaskProgressBlock)progress
    withCompletionBlockWithSuccess:(JDRequestCompletionBlock)success
                           failure:(JDRequestCompletionBlock)failure;
{
    return [JDUploadRequest startRequestWithUrl:url withName:name withImages:images withArguments:@{} withProgressBlock:progress withCompletionBlockWithSuccess:success failure:failure];
}
+(instancetype)startRequestWithUrl:(NSString*)url
                          withName:(NSString*)name
                        withImages:(NSArray*)images
                     withArguments:(NSDictionary*)arguments
                 withProgressBlock:(AFURLSessionTaskProgressBlock)progress
    withCompletionBlockWithSuccess:(JDRequestCompletionBlock)success
                           failure:(JDRequestCompletionBlock)failure
{
    
    JDUploadRequest  *req = [[JDUploadRequest  alloc]init];
    [req setJDRequestUrl:url];
    NSMutableDictionary  *dic = [[NSMutableDictionary  alloc]initWithDictionary:arguments];
    req.images = images;
    req.uploadName = name;
    [req setValue:dic forKey:@"argument"];
    [req isShowHUDConfig];
    req.uploadProgressBlock = progress;
    [req setCompletionBlockWithSuccess:^(__kindof JDUploadRequest * _Nonnull request) {
        NSLog(@"请求成功%@",request.filtResponseObj);
        success(request);
    } failure:^(__kindof JDBaseRequest * _Nonnull request) {
        NSLog(@"%@",[NSString stringWithFormat:@"*失败原因: %@",request.error]);
        if (failure) {
            failure(request);
        }
    }];
    [req start];
    return req;
}
+ (NSString *)nowTimestamp {
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];
    NSString *tempTime = [NSString stringWithFormat:@"%ld",timeSp];
    return tempTime;
}


-(void)isShowHUDConfig
{
 
//    DISPATCH_ON_MAIN_THREAD(^{
//        [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
//    });
}

@end
