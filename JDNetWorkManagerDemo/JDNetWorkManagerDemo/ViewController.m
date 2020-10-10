//
//  ViewController.m
//  JDNetWorkManagerDemo
//
//  Created by JDragon on 2019/8/8.
//  Copyright © 2019 JDragon. All rights reserved.
//

#import "ViewController.h"
#import "JDTestRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [JDNetApiManager configNetwork];
    JDTestRequest  *req = [JDTestRequest startRequestWithUrl:@"/app/mock/256054/checkoutOnline/transDetail" withExtendArguments:@{@"aaa":@"1233333"} withCompletionBlockWithSuccess:^(JDTestRequest * _Nonnull request) {
       
       NSLog(@"返回数据==%@",request.JDResponse.responseObject);
    }];
    
}


@end
