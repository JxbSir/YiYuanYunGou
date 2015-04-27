//
//  SettingFeedbackVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingFeedbackVC.h"

@interface SettingFeedbackVC ()<UITextViewDelegate>
{
    __block UITextView  *txtContent;
    UILabel             *lblInfo;
}
@end

@implementation SettingFeedbackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用户反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];

    [self actionCustomRightBtnWithNrlImage:@"submit" htlImage:@"submit" title:@"" action:^{
        [wSelf post];
    }];
    
    txtContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 250)];
    txtContent.delegate = self;
    [self.view addSubview:txtContent];
    
    lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, mainWidth - 20, 15)];
    lblInfo.text = @"我们将非常感谢您的反馈意见，有您的反馈意见，我们将会做到更好，谢谢";
    lblInfo.textColor = [UIColor lightGrayColor];
    lblInfo.font = [UIFont systemFontOfSize:14];
    lblInfo.numberOfLines = 0;
    lblInfo.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:lblInfo];
    
    CGSize s = [lblInfo.text textSizeWithFont:lblInfo.font constrainedToSize:CGSizeMake(mainWidth - 32, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblInfo.frame = CGRectMake(10, 10, mainWidth - 20, s.height);
    
}


- (void)post
{
    if (txtContent.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入反馈内容"];
        return;
    }
    [[UMFeedback sharedInstance] post:@{@"content":txtContent.text}];
    [[XBToastManager ShardInstance] showtoast:@"谢谢您的反馈"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [lblInfo setHidden:YES];
}
@end
