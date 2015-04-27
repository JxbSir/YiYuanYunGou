//
//  RegUserVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "RegUserVC.h"
#import "RegModel.h"
#import "RegUserNextVC.h"
#import "RegSetPwdVC.h"

@interface RegUserVC ()<UITextFieldDelegate>
{
    UITextField     *txtPhone;
}
@end

@implementation RegUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"注册";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 15, mainWidth - 32, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 3;
    [self.view addSubview:vvv];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    img.image = [UIImage imageNamed:@"sort100_normal"];
    [vvv addSubview:img];
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, mainWidth - 80, 34)];
    txtPhone.backgroundColor = [UIColor whiteColor];
    txtPhone.font = [UIFont systemFontOfSize:13];
    txtPhone.placeholder = @"请输入您的手机号";
    txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    txtPhone.delegate = self;
    [vvv addSubview:txtPhone];
    [txtPhone becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 75, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0)
    {
        if(textField.text.length > 10)
            return NO;
        if([string isEqualToString:@"0"])
            return YES;
        if([string intValue] == 0)
            return NO;
    }
    return YES;
}

- (void)btnAction
{
    if(![[Jxb_Common_Common sharedInstance] validatePhone:txtPhone.text])
    {
        [[XBToastManager ShardInstance] showtoast:@"输入的手机号不正确"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    [RegModel regPhoneSms:txtPhone.text success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        RegSms* sms = [[RegSms alloc] initWithDictionary:(NSDictionary*)result];
        if([sms.state intValue] == 3)
        {
            [[XBToastManager ShardInstance] showtoast:@"该手机号已经注册"];
            return ;
        }
        RegUserNextVC* vc = [[RegUserNextVC alloc] initWithPhone:txtPhone.text];
        //RegSetPwdVC* vc = [[RegSetPwdVC alloc] initWithStr:txtPhone.text];
        vc.hidesBottomBarWhenPushed = YES;
        [wSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
    }];
}
@end
