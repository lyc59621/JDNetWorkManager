//
//  ViewController.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "ViewController.h"
#import "JDTestRequest.h"
#import "TZImagePickerController.h"
#import "JDUploadRequest.h"


@interface ViewController ()<TZImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [JDNetApiManager configNetwork];
    JDTestRequest  *req = [JDTestRequest startRequestWithUrl:@"/app/mock/256054/checkoutOnline/transDetail" withExtendArguments:@{@"aaa":@"1233333"} withCompletionBlockWithSuccess:^(JDTestRequest * _Nonnull request) {
       
       NSLog(@"返回数据==%@",request.JDResponse.responseObject);
    }];
    [req start];
}
- (IBAction)testAction:(id)sender {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.selectedAssets = nil;
    imagePickerVc.allowPickingOriginalPhoto = true;
    imagePickerVc.allowPickingVideo = TRUE;
    imagePickerVc.naviBgColor = [UIColor redColor];
    imagePickerVc.naviTitleColor = [UIColor redColor];
    imagePickerVc.barItemTextColor = [UIColor redColor];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSLog(@"选择图片==%@",photos);
        [self uploadActionWithArray:photos];
        TZImageManager *manager = [TZImageManager manager];
        [manager getPhotoWithAsset:assets[0] completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
           
            if (!isDegraded) {//原图
                
                NSLog(@"图片信息==%@",info);
            }
        }];
       

    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        NSLog(@"选择视频==%@",asset);
        TZImageManager *manager = [TZImageManager manager];
        [manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            
            AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSLog(@"视频信息==%@",info);
            NSLog(@"视频地址==%@",url);
            
            [self uploadActionWithArray:@[url]];
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
-(void)uploadActionWithArray:(NSArray*)array
{
    
    [[JDUploadRequest startRequestWithUrl:@"" withName:@"dwad" withImages:array withProgressBlock:^(NSProgress * _Nonnull progress) {
        
    } withCompletionBlockWithSuccess:^(__kindof JDBaseRequest * _Nonnull request) {
        NSLog(@"上传成功=%@",request);

    } failure:^(__kindof JDBaseRequest * _Nonnull request) {
        NSLog(@"上传失败=%@",request.error);
    }] start] ;
    
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];

}
@end
