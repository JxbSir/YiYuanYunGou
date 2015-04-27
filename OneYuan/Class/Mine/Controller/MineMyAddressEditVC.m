//
//  MineMyAddressEditVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyAddressEditVC.h"
#import "LMComBoxView.h"
#import "MineMyAreaModel.h"

#define AllProNamelist  @[@"请选择",@"安徽省",@"北京",@"重庆",@"福建省",@"甘肃省",@"广东省",@"广西壮族自治区",@"贵州省",@"海南省",@"河北省",@"河南省",@"黑龙江省",@"湖北省",@"湖南省",@"吉林省",@"江苏省",@"江西省",@"辽宁省",@"内蒙古自治区",@"宁夏回族自治区",@"青海省",@"山东省",@"山西省",@"陕西省",@"上海",@"四川省",@"天津",@"西藏自治区",@"新疆维吾尔自治区",@"云南省",@"浙江省"]
#define AllProIdlist    @[@"0",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32"]

@interface MineMyAddressEditVC ()<LMComBoxViewDelegate,UITextFieldDelegate>
{
    __weak  id<MineMyAddressEditVCDelegate> delegate;
    
    __block MineMyAddressItem   *myAddressItem;
    __block LMComBoxView        *box1;
    __block LMComBoxView        *box2;
    __block LMComBoxView        *box3;
    __block LMComBoxView        *box4;
    
    __block UITextField         *txtAddress;
    __block UITextField         *txtName;
    __block UITextField         *txtPhone;
    
    __block int                 aid;
    __block int                 bid;
    __block int                 cid;
    __block int                 did;
    
    __block NSArray             *arrCity;
    __block NSArray             *arrQu;
    __block NSArray             *arrJie;
    
    __block BOOL                bDefault;
    
}
@end

@implementation MineMyAddressEditVC
@synthesize delegate;

- (id)initWithAddress:(MineMyAddressItem*)item
{
    self = [super init];
    if(self)
    {
        myAddressItem = item;
        if(myAddressItem)
        {
            aid = [myAddressItem.AID intValue];
            bid = [myAddressItem.BID intValue];
            cid = [myAddressItem.CID intValue];
            did = [myAddressItem.DID intValue];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    if(myAddressItem && [myAddressItem.ID intValue] > 0)
        self.title = @"更新地址";
    else
        self.title = @"新增地址";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
    CGFloat w = (mainWidth - 50) / 4;
    box1 = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, 10, w, 30)];
    box1.backgroundColor = [UIColor whiteColor];
    box1.arrowImgName = @"down_dark";
    box1.titlesList = [NSMutableArray arrayWithArray:AllProNamelist];
    box1.delegate = self;
    box1.supView = self.view;
    [box1 defaultSettings];
    [self.view addSubview:box1];
    
    
    box2 = [[LMComBoxView alloc] initWithFrame:CGRectMake(w + 20, 10, w, 30)];
    box2.backgroundColor = [UIColor whiteColor];
    box2.arrowImgName = @"down_dark";
    box2.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
    box2.delegate = self;
    box2.supView = self.view;
    [box2 defaultSettings];
    [self.view addSubview:box2];
    
    
    box3 = [[LMComBoxView alloc] initWithFrame:CGRectMake(2 * w + 30, 10, w, 30)];
    box3.backgroundColor = [UIColor whiteColor];
    box3.arrowImgName = @"down_dark";
    box3.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
    box3.delegate = self;
    box3.supView = self.view;
    [box3 defaultSettings];
    [self.view addSubview:box3];
    
    
    box4 = [[LMComBoxView alloc] initWithFrame:CGRectMake(3 * w + 40,10 , w, 30)];
    box4.backgroundColor = [UIColor whiteColor];
    box4.arrowImgName = @"down_dark";
    box4.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
    box4.delegate = self;
    box4.supView = self.view;
    [box4 defaultSettings];
    [self.view addSubview:box4];
    
    txtAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, mainWidth - 20, 44)];
    txtAddress.text = myAddressItem.Address;
    txtAddress.backgroundColor = [UIColor whiteColor];
    txtAddress.placeholder = @"请输入详细收货地址";
    txtAddress.font = [UIFont systemFontOfSize:13];
    txtAddress.layer.cornerRadius = 5;
    txtAddress.layer.borderWidth = 0.5;
    txtAddress.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
    [self.view addSubview:txtAddress];
    
    txtName = [[UITextField alloc] initWithFrame:CGRectMake(10, 105, mainWidth / 2 - 20, 44)];
    txtName.text = myAddressItem.Name;
    txtName.backgroundColor = [UIColor whiteColor];
    txtName.placeholder = @"请输入收货人";
    txtName.font = [UIFont systemFontOfSize:13];
    txtName.layer.cornerRadius = 5;
    txtName.layer.borderWidth = 0.5;
    txtName.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
    [self.view addSubview:txtName];
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(mainWidth/2 +10, 105, mainWidth / 2 - 20, 44)];
    txtPhone.text = myAddressItem.Mobile;
    txtPhone.backgroundColor = [UIColor whiteColor];
    txtPhone.placeholder = @"请输入收货手机号";
    txtPhone.font = [UIFont systemFontOfSize:13];
    txtPhone.layer.cornerRadius = 5;
    txtPhone.layer.borderWidth = 0.5;
    txtPhone.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
    txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    txtPhone.delegate = self;
    [self.view addSubview:txtPhone];
    
//    UIButton* ckb = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, 24, 24)];
//    [ckb setImage:[UIImage imageNamed:@"ckb2"] forState:UIControlStateNormal];
//    [ckb setImage:[UIImage imageNamed:@"ckb2"] forState:UIControlStateHighlighted];
//    [ckb addTarget:self action:@selector(ckbAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:ckb];
//    
//    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 175, 100, 13)];
//    lbl.text = @"设为默认地址";
//    lbl.textColor = [UIColor lightGrayColor];
//    lbl.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:lbl];
    
    UIButton* btnOK = [[UIButton alloc] initWithFrame:CGRectMake(10, 160, mainWidth - 20, 40)];
    [btnOK setTitle:@"提交" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:mainColor];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.layer.cornerRadius = 5;
    [btnOK addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOK];
    
    
    if(aid > 0)
    {
        int index = 0;
        for (int i = 0; i < AllProIdlist.count; i++) {
            if(aid == [[AllProIdlist objectAtIndex:i] intValue])
            {
                index = i;
                break;
            }
        }
        [box1 setDefaultIndex:index];
        [box1 reloadData];
        
        [MineMyAreaModel getArea:aid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            int index1 = 0;
            for(int i = 0; i < item.str.regions.count; i++)
            {
                MineMyAreaItem* city = [item.str.regions objectAtIndex:i];
                [arr addObject:city.name];
                [arr2 addObject:city.id];
                if([city.id intValue] == bid)
                    index1 = i+1;
            }
            arrCity = arr2;
            box2.titlesList = arr;
            [box2 setDefaultIndex:index1];
            [box2 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    if(bid > 0)
    {
        [MineMyAreaModel getArea:bid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            int index1 = 0;
            for(int i = 0; i < item.str.regions.count; i++)
            {
                MineMyAreaItem* city = [item.str.regions objectAtIndex:i];
                [arr addObject:city.name];
                [arr2 addObject:city.id];
                if([city.id intValue] == cid)
                    index1 = i+1;
            }
            arrQu = arr2;
            box3.titlesList = arr;
            [box3 setDefaultIndex:index1];
            [box3 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    if(cid > 0)
    {
        [MineMyAreaModel getArea:cid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            int index1 = 0;
            for(int i = 0; i < item.str.regions.count; i++)
            {
                MineMyAreaItem* city = [item.str.regions objectAtIndex:i];
                [arr addObject:city.name];
                [arr2 addObject:city.id];
                if([city.id intValue] == did)
                    index1 = i+1;
            }
            arrJie = arr2;
            box4.titlesList = arr;
            [box4 setDefaultIndex:index1];
            [box4 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    
}

#pragma mark - action
- (void)ckbAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    bDefault = !bDefault;
    [btn setImage:[UIImage imageNamed:bDefault ? @"ckb1" : @"ckb2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:bDefault ? @"ckb1" : @"ckb2"] forState:UIControlStateHighlighted];
}

- (void)submitAction
{
    if(did == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请先选择地区"];
        return;
    }
    if(txtAddress.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入详细地址"];
        return;
    }
    if(txtName.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入收货人"];
        return;
    }
    if(txtPhone.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入收货手机号"];
        return;
    }
    if(![[Jxb_Common_Common sharedInstance] validatePhone:txtPhone.text])
    {
        [[XBToastManager ShardInstance] showtoast:@"输入的手机号不正确"];
        return;
    }
    
    __weak typeof (self) wSelf = self;
    
    NSDictionary* dicP = @{
                            @"action":@"saveMemberContact",
                            @"contactID":myAddressItem.ID ? myAddressItem.ID : @"",
                            @"areaCID":[NSNumber numberWithInt:cid],
                            @"areaDID":[NSNumber numberWithInt:did],
                            @"shipAddress":txtAddress.text,
                            @"shipName":txtName.text,
                            @"shipMobile":txtPhone.text
                           };
    [MineMyAddressModel addMyAddress:dicP success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSString* r = (NSString*)result;
        if([[Jxb_Common_Common sharedInstance] containString:r cStr:@"code':0"])
        {
            [[XBToastManager ShardInstance] showtoast:@"地址添加成功"];
            [delegate refreshAddress];
            [wSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[XBToastManager ShardInstance] showtoast:@"地址添加失败"];
        }
    } failure:^(NSError* error){
        
    }];
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:txtPhone])
    {
        if(string.length > 0)
        {
            if(textField.text.length > 10)
                return NO;
            if(![string isEqualToString:@"0"] && [string intValue] == 0)
                return NO;
        }
    }
    return YES;
}

- (void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    if([_combox isEqual:box1])
    {
        aid = [[AllProIdlist objectAtIndex:index] intValue];
        bid = 0;
        box2.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box2.defaultIndex = 0;
        [box2 reloadData];
        cid = 0;
        box3.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box3.defaultIndex = 0;
        [box3 reloadData];
        did = 0;
        box4.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box4.defaultIndex = 0;
        [box4 reloadData];
        
        [MineMyAreaModel getArea:aid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            for(MineMyAreaItem* city in item.str.regions)
            {
                [arr addObject:city.name];
                [arr2 addObject:city.id];
            }
            arrCity = arr2;
            box2.titlesList = arr;
            [box2 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    else if([_combox isEqual:box2])
    {
        bid = [[arrCity objectAtIndex:index] intValue];
        cid = 0;
        box3.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box3.defaultIndex = 0;
        [box3 reloadData];
        did = 0;
        box4.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box4.defaultIndex = 0;
        [box4 reloadData];
        
        [MineMyAreaModel getArea:bid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            for(MineMyAreaItem* city in item.str.regions)
            {
                [arr addObject:city.name];
                [arr2 addObject:city.id];
            }
            arrQu = arr2;
            box3.titlesList = arr;
            [box3 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    else if([_combox isEqual:box3])
    {
        cid = [[arrQu objectAtIndex:index] intValue];
        did = 0;
        box4.titlesList = [NSMutableArray arrayWithArray:@[@"请选择"]];
        box4.defaultIndex = 0;
        [box4 reloadData];
        
        [MineMyAreaModel getArea:cid success:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSDictionary* dic = (NSDictionary*)result;
            MineMyAreaInfo* item = [[MineMyAreaInfo alloc] initWithDictionary:dic];
            NSMutableArray* arr = [NSMutableArray arrayWithObject:@"请选择"];
            NSMutableArray* arr2 = [NSMutableArray arrayWithObject:@"0"];
            for(MineMyAreaItem* city in item.str.regions)
            {
                [arr addObject:city.name];
                [arr2 addObject:city.id];
            }
            arrJie = arr2;
            box4.titlesList = arr;
            [box4 reloadData];
        } failure:^(NSError* error){
            
        }];
    }
    else if([_combox isEqual:box4])
    {
        did = [[arrJie objectAtIndex:index] intValue];
    }
}

@end
