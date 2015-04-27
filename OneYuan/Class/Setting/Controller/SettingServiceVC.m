//
//  SettingServiceVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingServiceVC.h"

@implementation SettingServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"服务协议";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UITextView* txt = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, mainWidth - 20, self.view.bounds.size.height)];
    [txt setEditable:NO];
    [self.view addSubview:txt];
    
    txt.text = @"        欢迎您访问并使用一元云购IOS客户端，本App中的所有数据均来自一元云购（www.1yyg.com）平台，真实有效，并对数据不做任何保留。\r\n\r\n        我们的服务宗旨就是：为广大云购朋友提供免费的便利。\r\n\r\n        此客户端并非一元云购开发的官方产品，由于为了方便广大云购朋友能够在手机上也能玩云购，我们才开发此App，我们也是一元云购的忠实玩家。\r\n\r\n        一切规则以官方平台：一元云购 为准。\r\n\r\n        本人保留该声明条款的最终解释权和不定时修改的权利。";
    
    
}

@end
