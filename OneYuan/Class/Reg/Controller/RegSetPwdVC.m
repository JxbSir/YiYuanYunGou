//
//  RegSetPwdVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "RegSetPwdVC.h"
#import "RegModel.h"
#import "UserInstance.h"
#import "LoginModel.h"

@interface RegSetPwdVC ()<UITextFieldDelegate>
{
    NSString* myPhone;
    NSString* myStr;
    
    __block UITextField     *txtPwd;
}
@end

@implementation RegSetPwdVC

- (id)initWithStr:(NSString*)str phone:(NSString*)phone
{
    self = [super init];
    if(self)
    {
        myPhone = phone;
        myStr = str;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"设置密码";
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
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    img.image = [UIImage imageNamed:@"login_password"];
    [vvv addSubview:img];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, mainWidth - 80, 34)];
    txtPwd.backgroundColor = [UIColor whiteColor];
    txtPwd.font = [UIFont systemFontOfSize:13];
    txtPwd.placeholder = @"请输入长度6-20位的登录密码";
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.keyboardType = UIKeyboardAppearanceDefault;
    txtPwd.delegate = self;
    [vvv addSubview:txtPwd];
    [txtPwd becomeFirstResponder];
    
    UIButton* btnDone = [[UIButton alloc] initWithFrame:CGRectMake(16, 75, mainWidth - 32, 44)];
    btnDone.backgroundColor = mainColor;
    [btnDone setTitle:@"完成注册" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5;
    [btnDone addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 0 && textField.text.length > 19)
    {
        return false;
    }
    return YES;
}

- (void)btnAction
{
    if(txtPwd.text.length < 6 || txtPwd.text.length > 20)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入6-20位的密码"];
        return;
    }
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    [RegModel regPhoneSetPwd:myStr pwd:txtPwd.text success:^(AFHTTPRequestOperation* operation1, NSObject* result1){
        RegSms* r = [[RegSms alloc] initWithDictionary:(NSDictionary*)result1];
        if([r.state intValue] != 0)
        {
            [[XBToastManager ShardInstance] hideprogress];
            return ;
        }
        [wSelf doLogin];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
    }];
}

- (void)doLogin
{
    __weak typeof (self) wSelf = self;
    [LoginModel doLogin:myPhone pwd:txtPwd.text success:^(AFHTTPRequestOperation* operation, NSObject* result){
        LoginParser* parser = [[LoginParser alloc] initWithDictionary:(NSDictionary*)result];
        if ([parser.state intValue] == 0)
        {
            NSString* cookies = [[operation.response allHeaderFields] objectForKey:@"Set-Cookie"];
            
            NSString* uid = [[Jxb_Common_Common sharedInstance] getMidString:cookies front:@"_uid=" end:@";"];
            NSString* auth = [[Jxb_Common_Common sharedInstance] getMidString:cookies front:@"_auth=" end:@";"];
            NSString* cookie = [NSString stringWithFormat:@"_uName=%@;_uid=%@;_auth=%@",myPhone,uid,auth];
            [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:kXBCookie];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [LoginModel doLoginOK:^(AFHTTPRequestOperation* operation2,NSObject* result2){
                LoginOkParser* parser2 = [[LoginOkParser alloc] initWithDictionary:(NSDictionary*)result2];
                [[XBToastManager ShardInstance] hideprogress];
                if ([parser2.code integerValue] == 0)
                {
                    [[UserInstance ShardInstnce] isUserStillOnline];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:myPhone forKey:kLoginUsername];
                    NSString* cookies2 = [[operation2.response allHeaderFields] objectForKey:@"Set-Cookie"];
                    NSString* _mlgAuth = [[Jxb_Common_Common sharedInstance] getMidString:cookies2 front:@"_mlgAuth=" end:@";"];
                    
                    NSString* cookie2 = [NSString stringWithFormat:@"_uName=%@;_uid=%@;_auth=%@;_mlgAuth=%@",myPhone,uid,auth,_mlgAuth];
                    [[NSUserDefaults standardUserDefaults] setObject:cookie2 forKey:kXBCookie];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [wSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            } failure:^(NSError* error2){
                [[XBToastManager ShardInstance] hideprogress];
            }];
            
        }
        else{
            [[XBToastManager ShardInstance] hideprogress];
            int code = [parser.state intValue];
            if(code==1)
            {
                [[XBToastManager ShardInstance] showtoast:@"您输入的密码不正确"];
            }
            else
                [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"登录失败:%d",[parser.state intValue]]];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@"登录失败"];
    }];
}
@end
