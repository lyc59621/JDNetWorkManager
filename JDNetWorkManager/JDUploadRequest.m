//
//  JDUploadRequest.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "JDUploadRequest.h"
#import <JDragonNetWork/JDNetwork.h>
#import <AFNetworking/AFNetworking.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>

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
            
            NSObject *obj = weakSelf.images[i];
            if ([obj isKindOfClass:[UIImage class]]) {
                UIImage  *image = (UIImage*)obj;
                NSData *data = UIImageJPEGRepresentation(image, 1);
                [weakSelf appendImageDataActionWithFormData:formData withObj:data];
            }else
            if ([obj isMemberOfClass:[NSData class]]){
                [weakSelf appendAssetActionWithFormData:formData withObj:obj];
            }else
            if ([obj isMemberOfClass:[NSURL class]]) {
                [weakSelf appendUrlActionWithFormData:formData withObj:obj];
            }else
            if ([obj isMemberOfClass:[PHAsset class]]){
                [weakSelf appendAssetActionWithFormData:formData withObj:obj];
            }
        }
    };
}
-(void)appendImageDataActionWithFormData:(id<AFMultipartFormData>)formData  withObj:(NSObject*)obj
{
    NSData *data = (NSData*)obj;
    if (data) {
        NSString *fileName = [NSString stringWithFormat:@"JD_image_%@_%@.jpeg",self.uploadName,[JDUploadRequest nowTimestamp]];
        NSString *type = @"image/png/jpeg";
        [formData appendPartWithFileData:data name:self.uploadName fileName:fileName mimeType:type];
    }
}

-(void)appendGifDataActionWithFormData:(id<AFMultipartFormData>)formData  withObj:(NSObject*)obj
{
    NSData  *data = (NSData*)obj;
    NSString *fileName = [NSString stringWithFormat:@"JD_%@_%@.gif",self.uploadName,[JDUploadRequest nowTimestamp]];
    NSString *mimeType = [NSString stringWithFormat:@"image/gif"];
    [formData appendPartWithFileData:data name:self.uploadName fileName:fileName mimeType:mimeType];
}
-(void)appendUrlActionWithFormData:(id<AFMultipartFormData>)formData  withObj:(NSObject*)obj
{
    NSURL  *url = (NSURL*)obj;
    if (url) {
        NSString *extension = [url pathExtension];
        NSString *fileName = [NSString stringWithFormat:@"JD_%@_%@.%@",self.uploadName,[JDUploadRequest nowTimestamp],extension];
        NSString *mimeType = [NSString stringWithFormat:@"video/%@", extension];
        NSError *error;
        [formData appendPartWithFileURL:url name:self.uploadName fileName:fileName mimeType:mimeType error:&error];
        if (error) {
            NSLog(@"上传文件error:%@",error);
        }
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
//        [formData appendPartWithFileData:videoData name:weakSelf.uploadName fileName:fileName mimeType:mimeType];
    }
}
-(void)appendAssetActionWithFormData:(id<AFMultipartFormData>)formData  withObj:(NSObject*)obj
{
    PHAsset *asset =(PHAsset*)obj;
    __weak __typeof(&*self)weakSelf = self;
    if (asset.mediaType==PHAssetMediaTypeImage) {
        
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                   
            if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                
                [weakSelf appendGifDataActionWithFormData:formData withObj:imageData];
            }else
            {
                [weakSelf appendImageDataActionWithFormData:formData withObj:imageData];
            }
        }];
    }else
    if (asset.mediaType==PHAssetMediaTypeVideo)
    {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            [weakSelf appendUrlActionWithFormData:formData withObj:url];
        }];
    }
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
        NSLog(@"请求成功%@",request);
        success(request);
    } failure:^(__kindof JDBaseRequest * _Nonnull request) {
        NSLog(@"%@",[NSString stringWithFormat:@"*失败原因: %@",request.error]);
        if (failure) {
            failure(request);
        }
    }];
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
