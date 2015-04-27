//
//  LoginVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "LoginVC.h"
#import "LoginModel.h"
#import "UserInstance.h"
#import "RegUserVC.h"

@interface LoginVC ()
{
    UITextField     *txtUser;
    UITextField     *txtPwd;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf btnBackAction];
    }];
    
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, mainWidth - 32, 0.5)];
    line1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line1];
    
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 108, mainWidth - 32, 0.5)];
    line3.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line3];
    
    UIImageView* line4 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 0.5, 88)];
    line4.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line4];
    
    UIImageView* line5 = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 16, 20, 0.5, 88)];
    line5.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line5];
    
    UIView* vUser = [[UIView alloc] initWithFrame:CGRectMake(16.5, 20.5, mainWidth - 33, 87)];
    vUser.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vUser];
    
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 64, mainWidth - 32, 0.5)];
    line2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line2];

    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
    imgUser.image = [UIImage imageNamed:@"login_name"];
    [vUser addSubview:imgUser];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, vUser.frame.size.width - 35, 44)];
    txtUser.placeholder = @"请输入您的手机号/邮箱号";
    txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtUser.font = [UIFont systemFontOfSize:14];
    txtUser.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUsername];
    [vUser addSubview:txtUser];
    
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 56, 20, 20)];
    imgPwd.image = [UIImage imageNamed:@"login_password"];
    [vUser addSubview:imgPwd];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(35, 44, vUser.frame.size.width - 35, 44)];
    txtPwd.placeholder = @"请输入您的密码";
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.font = [UIFont systemFontOfSize:14];
    txtPwd.secureTextEntry = YES;
    [vUser addSubview:txtPwd];
    
    UIButton* btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(16, 120, mainWidth - 32, 44)];
    btnLogin.layer.cornerRadius = 5;
    btnLogin.backgroundColor = mainColor;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    
//    UIButton* btnFind = [[UIButton alloc] init];
//    [btnFind setTitle:@"找回密码?" forState:UIControlStateNormal];
//    btnFind.titleLabel.font = [UIFont systemFontOfSize:13];
//    [btnFind setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.view addSubview:btnFind];
//    
//    CGSize s = [btnFind.titleLabel.text textSizeWithFont:btnFind.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
//    btnFind.frame = CGRectMake(mainWidth / 2 - s.width - 20, 180, s.width, 44);
    
    UIButton* btnReg = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 120, 170, 100, 44)];
    [btnReg setTitle:@"新用户注册" forState:UIControlStateNormal];
    btnReg.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnReg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnReg addTarget:self action:@selector(btnRegAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReg];
    
//    s = [btnReg.titleLabel.text textSizeWithFont:btnReg.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
//    btnReg.frame = CGRectMake(mainWidth / 2 + 20, 180, s.width, 44);
    
//    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth/ 2 - 0.5, 190, 0.5, 24)];
//    imgLine.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:imgLine];
}

#pragma mark - action
- (void)btnRegAction
{
    RegUserVC* vc  = [[RegUserVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnLoginAction
{
    if(txtUser.text.length==0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入账号"];
        return;
    }
    if(txtPwd.text.length==0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入密码"];
        return;
    }
    [[XBToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    [LoginModel doLogin:txtUser.text pwd:txtPwd.text success:^(AFHTTPRequestOperation* operation, NSObject* result){
        LoginParser* parser = [[LoginParser alloc] initWithDictionary:(NSDictionary*)result];
        if ([parser.state intValue] == 0)
        {
            NSString* cookies = [[operation.response allHeaderFields] objectForKey:@"Set-Cookie"];
            
            NSString* uid = [[Jxb_Common_Common sharedInstance] getMidString:cookies front:@"_uid=" end:@";"];
            NSString* auth = [[Jxb_Common_Common sharedInstance] getMidString:cookies front:@"_auth=" end:@";"];
            NSString* cookie = [NSString stringWithFormat:@"_uName=%@;_uid=%@;_auth=%@",txtUser.text,uid,auth];
            [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:kXBCookie];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [LoginModel doLoginOK:^(AFHTTPRequestOperation* operation2,NSObject* result2){
                LoginOkParser* parser2 = [[LoginOkParser alloc] initWithDictionary:(NSDictionary*)result2];
                [[XBToastManager ShardInstance] hideprogress];
                if ([parser2.code integerValue] == 0)
                {
                    [[UserInstance ShardInstnce] isUserStillOnline];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:txtUser.text forKey:kLoginUsername];
                    NSString* cookies2 = [[operation2.response allHeaderFields] objectForKey:@"Set-Cookie"];
                    NSString* _mlgAuth = [[Jxb_Common_Common sharedInstance] getMidString:cookies2 front:@"_mlgAuth=" end:@";"];
                    
                    NSString* cookie2 = [NSString stringWithFormat:@"_uName=%@;_uid=%@;_auth=%@;_mlgAuth=%@",txtUser.text,uid,auth,_mlgAuth];
                    [[NSUserDefaults standardUserDefaults] setObject:cookie2 forKey:kXBCookie];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [wSelf btnBackAction];
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
       // [[XBToastManager ShardInstance] showtoast:@"登录失败"];
    }];

}
@end
