//
//  SettingFeedListVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/10.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingFeedListVC.h"
#import "SettingFeedCell.h"

@interface SettingFeedListVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    
    __block UIView          *vInput;
    __block UITextField     *txtInput;
    __block UIButton        *btnSend;
    
    NSTimer                 *timer;
}
@end

@implementation SettingFeedListVC

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"我的反馈";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];

    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTxt)];
    [tbView addGestureRecognizer:tap];
    [self.view addSubview:tbView];
    
    [self getData:YES];
    
    vInput = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 108, mainWidth, 44)];
    vInput.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
    imgLine.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [vInput addSubview:imgLine];
    
    txtInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, mainWidth - 110, 34)];
    txtInput.layer.cornerRadius = 5;
    txtInput.layer.borderWidth = 0.5;
    txtInput.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
    txtInput.placeholder = @"请输入反馈内容";
    txtInput.delegate = self;
    [vInput addSubview:txtInput];
    
    btnSend = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 90, 5, 80, 34)];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSend setBackgroundColor:[UIColor hexFloatColor:@"dedede"]];
    btnSend.layer.cornerRadius = 5;
    btnSend.enabled = false;
    [btnSend addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [vInput addSubview:btnSend];
    
    [self.view addSubview:vInput];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getData:) userInfo:nil repeats:YES];
    
}

- (void)getData:(BOOL)bRollBottom
{
    [[Jxb_Common_Common sharedInstance] doInChildThread:^{
        [[UMFeedback sharedInstance] get];
        arrData = [[UMFeedback sharedInstance] topicAndReplies];
        [[Jxb_Common_Common sharedInstance] doInMainThread:^{
            [tbView reloadData];
            if(arrData.count > 0 && bRollBottom)
                [tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:arrData.count - 1]
                                      atScrollPosition: UITableViewScrollPositionBottom
                                              animated:NO];
        }];
    }];
}

#pragma mark - keyboard
- (void)keyboardShow:(NSNotification*)aNotification
{
    __weak typeof (self) wSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        CGSize kbSize = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        vInput.frame = CGRectMake(0, wSelf.view.bounds.size.height - kbSize.height - 44, mainWidth, 44);
        
        tbView.frame = CGRectMake(0, 0, mainWidth, wSelf.view.bounds.size.height - kbSize.height - 44);
        if(arrData.count > 0)
            [tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:arrData.count - 1]
                                                                                                                atScrollPosition: UITableViewScrollPositionBottom
                                                                                                                        animated:NO];
    }];
}

- (void)keyboardHide:(NSNotification*)aNotification
{
    __weak typeof (self) wSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        vInput.frame = CGRectMake(0, wSelf.view.bounds.size.height - 44, mainWidth,44);
        
        tbView.frame = CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 44);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        BOOL isEmpty = NO;
        if(string.length == 0 && txtInput.text.length <= 1)
        {
            isEmpty = YES;
        }
        else
            isEmpty = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
        btnSend.enabled = !isEmpty;
        btnSend.backgroundColor = isEmpty ? [UIColor hexFloatColor:@"dedede"] : mainColor;
    }
    else
    {
        btnSend.enabled = YES;
        btnSend.backgroundColor = mainColor;
    }
    
    return YES;
}

- (void)submit
{
    if (txtInput.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入反馈内容"];
        return;
    }
    [[UMFeedback sharedInstance] post:@{@"content":txtInput.text}];
    txtInput.text = @"";
    
    [self getData:YES];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [arrData objectAtIndex:indexPath.section];
    NSString* content = [item objectForKey:@"content"];
    CGSize s = [content textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(mainWidth - headWidth - 50, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    return s.height + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary* item = [arrData objectAtIndex:section];
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 20)];
    vvv.backgroundColor = [UIColor clearColor];
    
    double t = [[item objectForKey:@"created_at"] doubleValue];
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:t / 1000];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dStr = [f stringFromDate:d];
    
    UILabel* lblTime = [[UILabel alloc] init];
    lblTime.font = [UIFont systemFontOfSize:11];
    lblTime.text = [NSString stringWithFormat:@" %@ ",dStr];
    lblTime.textColor = [UIColor whiteColor];
    lblTime.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    lblTime.layer.cornerRadius = 3;
    lblTime.layer.masksToBounds = YES;
    [vvv addSubview:lblTime];
    
    CGSize s  = [lblTime.text textSizeWithFont:lblTime.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTime.frame = CGRectMake((mainWidth - s.width) / 2, 5, s.width, s.height);
    
    return vvv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [arrData objectAtIndex:indexPath.section];
    
    static NSString *CellIdentifier = @"setFeedCell";
    SettingFeedCell *cell = (SettingFeedCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[SettingFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setFeed:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self resignTxt];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignTxt];
}

- (void)resignTxt
{
    [txtInput resignFirstResponder];
}
@end
