//
//  RegUserNextVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "RegUserNextVC.h"
#import "RegModel.h"
#import "UserInstance.h"
#import "LoginModel.h"
#import "RegSetPwdVC.h"

#define timeWait    150

@interface RegUserNextVC ()<UITextFieldDelegate>
{
    __block NSString    *myPhone;
    __block int         leftTime;
    __block NSTimer     *timer;
    __block UITextField *txtCode;
    __block UIButton    *btnResend;
}
@end

@implementation RegUserNextVC

- (void)viewWillDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
    }
    [super viewWillDisappear:animated];
}

- (id)initWithPhone:(NSString*)phone
{
    self = [super init];
    if(self)
    {
        myPhone = phone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"注册";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, mainWidth - 32, 15)];
    lbl.text = @"已将验证码发送到您的手机，请注意查收";
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(16, 40, 150, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    vvv.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    vvv.layer.borderWidth = 0.5;
    vvv.layer.cornerRadius = 3;
    [self.view addSubview:vvv];
    
    txtCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 120, 34)];
    txtCode.backgroundColor = [UIColor whiteColor];
    txtCode.font = [UIFont systemFontOfSize:13];
    txtCode.placeholder = @"请输入6位验证码";
    txtCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtCode.keyboardType = UIKeyboardTypeNumberPad;
    txtCode.delegate = self;
    [vvv addSubview:txtCode];
    
    btnResend = [[UIButton alloc] initWithFrame:CGRectMake(180, 40, mainWidth - 196, 44)];
    btnResend.backgroundColor = [UIColor whiteColor];
    btnResend.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",timeWait] forState:UIControlStateNormal];
    [btnResend setTitleColor:mainColor forState:UIControlStateNormal];
    btnResend.layer.cornerRadius = 5;
    btnResend.layer.borderWidth = 0.5;
    btnResend.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
    [btnResend addTarget:self action:@selector(btnResendAction) forControlEvents:UIControlEventTouchUpInside];
    [btnResend setEnabled:NO];
    [self.view addSubview:btnResend];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 95, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"下一步" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnNextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];

    
    leftTime = timeWait;
    if(timer)
        [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0)
    {
        if(textField.text.length > 5)
            return NO;
        if([string isEqualToString:@"0"])
            return YES;
        if([string intValue] == 0)
            return NO;
    }
    return YES;
}

- (void)timerAction
{
    leftTime--;
    if(leftTime<=0)
    {
        [btnResend setEnabled:YES];
        [btnResend setTitle:@"点击重新发送" forState:UIControlStateNormal];
        [btnResend setTitle:@"点击重新发送" forState:UIControlStateDisabled];
    }
    else
    {
        [btnResend setEnabled:NO];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
    }
}

- (void)btnNextAction
{
    if(txtCode.text.length != 6)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入正确的验证码"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    [RegModel regPhoneCode:myPhone code:txtCode.text success:^(AFHTTPRequestOperation* operation, NSObject* result){
        //NSDictionary* dic = [operation.response allHeaderFields];
        [[XBToastManager ShardInstance] hideprogress];
        RegResut* p = [[RegResut alloc] initWithDictionary:(NSDictionary*)result];
        if([p.code intValue] == 1)
        {
            [[XBToastManager ShardInstance] hideprogress];
            [[XBToastManager ShardInstance] showtoast:@"验证码校验不正确[1]"];
            return ;
        }
        if([p.state intValue] == 1)
        {
            [[XBToastManager ShardInstance] showtoast:@"验证码校验不正确[2]"];
            return;
        }
        if([p.state intValue] == 0)
        {
            RegSetPwdVC* vc = [[RegSetPwdVC alloc] initWithStr:p.str phone:myPhone];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
    }];
}

- (void)btnResendAction
{
    [[XBToastManager ShardInstance] showprogress];
    [RegModel regPhoneSms:myPhone success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        RegSms* sms = [[RegSms alloc] initWithDictionary:(NSDictionary*)result];
        if([sms.state intValue] == 3)
        {
            [[XBToastManager ShardInstance] showtoast:@"该手机号已经注册"];
            return ;
        }
        
        leftTime = timeWait;
        [btnResend setEnabled:NO];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateNormal];
        [btnResend setTitle:[NSString stringWithFormat:@"%d秒后可以重新发送",leftTime] forState:UIControlStateDisabled];
        
        if(timer)
            [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        
    }];
    
}
@end
