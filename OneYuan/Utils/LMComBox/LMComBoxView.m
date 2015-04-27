//
//  LMComBoxView.m
//  ComboBox
//
//  Created by tkinghr on 14-7-9.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LMComBoxView.h"

@implementation LMComBoxView
@synthesize isOpen = _isOpen;
@synthesize listTable = _listTable;
@synthesize titlesList = _titlesList;
@synthesize defaultIndex = _defaultIndex;
@synthesize tableHeight = _tableHeight;
@synthesize arrow = _arrow;
@synthesize arrowImgName = _arrowImgName;
@synthesize delegate = _delegate;
@synthesize supView = _supView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)defaultSettings
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = kBorderColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.clipsToBounds = YES;
    btn.layer.masksToBounds = YES;
    btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width-imgW - 5 - 2, self.frame.size.height)];
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kTextColor;
    [btn addSubview:titleLabel];
    
    _arrow = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - imgW - 2, (self.frame.size.height-imgH)/2.0, imgW, imgH)];
    _arrow.image = [UIImage imageNamed:_arrowImgName];
    [btn addSubview:_arrow];
    
    //默认不展开
    _isOpen = NO;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0) style:UITableViewStylePlain];
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.layer.borderWidth = 0.5;
    _listTable.layer.borderColor = kBorderColor.CGColor;
    
    [_supView addSubview:_listTable];
    
    titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
}

//刷新视图
-(void)reloadData
{
    [_listTable reloadData];
    titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
}

//关闭父视图上面的其他combox
-(void)closeOtherCombox
{
    for(UIView *subView in _supView.subviews)
    {
        if([subView isKindOfClass:[LMComBoxView class]]&&subView!=self)
        {
            LMComBoxView *otherCombox = (LMComBoxView *)subView;
            if(otherCombox.isOpen)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = otherCombox.listTable.frame;
                    frame.size.height = 0;
                    [otherCombox.listTable setFrame:frame];
                } completion:^(BOOL finished){
                    [otherCombox.listTable removeFromSuperview];
                    otherCombox.isOpen = NO;
                    otherCombox.arrow.transform = CGAffineTransformRotate(otherCombox.arrow.transform, DEGREES_TO_RADIANS(180));
                }];
            }
        }
    }
}

//点击事件
-(void)tapAction
{
    //关闭其他combox
    [self closeOtherCombox];

    if(_isOpen)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _listTable.frame;
            frame.size.height = 0;
            [_listTable setFrame:frame];
        } completion:^(BOOL finished){
            [_listTable removeFromSuperview];//移除
            _isOpen = NO;
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
            }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            if(_titlesList.count>0)
            {
                /*
                 
                    注意：如果不加这句话，下面的操作会导致_listTable从上面飘下来的感觉：
                         _listTable展开并且滑动到底部 -> 点击收起 -> 再点击展开
                 */
                [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            [_supView addSubview:_listTable];
            [_supView bringSubviewToFront:_listTable];//避免被其他子视图遮盖住
            CGRect frame = _listTable.frame;
            frame.size.height = _tableHeight>0?_tableHeight:tableH;
            float height = [UIScreen mainScreen].bounds.size.height;
            if(frame.origin.y+frame.size.height>height)
            {
                //避免超出屏幕外
                frame.size.height -= frame.origin.y + frame.size.height - height;
            }
            [_listTable setFrame:frame];
        } completion:^(BOOL finished){
            _isOpen = YES;
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
        }];
    }
}

#pragma mark -tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width-4, self.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = kTextColor;
        label.tag = 1000;
        [cell addSubview:label];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = kBorderColor;
        [cell addSubview:line];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [_titlesList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    titleLabel.text = [_titlesList objectAtIndex:indexPath.row];
    _isOpen = YES;
    [self tapAction];
    if([_delegate respondsToSelector:@selector(selectAtIndex:inCombox:)])
    {
        [_delegate selectAtIndex:(int)indexPath.row inCombox:self];
    }
    [self performSelector:@selector(deSelectedRow) withObject:nil afterDelay:0.2];
}

-(void)deSelectedRow
{
    [_listTable deselectRowAtIndexPath:[_listTable indexPathForSelectedRow] animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
