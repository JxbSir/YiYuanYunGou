//
//  MineRechargeVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineRechargeVC.h"

@interface MineRechargeVC ()

@end

@implementation MineRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    
    self.title = @"充值";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.1yyg.com/member/recharge.do"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}


@end
