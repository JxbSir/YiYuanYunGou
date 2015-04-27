//
//  HomeOrderShowCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeOrderShowCell.h"
#import "HomeOrderShowView.h"
#import "HomeModel.h"
#import "HomeInstance.h"

@interface HomeOrderShowCell ()
{
    __weak id<HomeOrderShowCellDelegate> delegate;
    
    HomeOrderShowView* vShow1;
    HomeOrderShowView* vShow2;
    HomeOrderShowView* vShow3;
}

@end

@implementation HomeOrderShowCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        vShow1 = [[HomeOrderShowView alloc] initWithFrame:CGRectMake(0, 0, mainWidth / 2 - 5, 250)];
        [self addSubview:vShow1];
        
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
        [vShow1 addGestureRecognizer:tap1];
        
        
        vShow2 = [[HomeOrderShowView alloc] initWithFrame:CGRectMake(mainWidth/2+5, 0, mainWidth / 2 - 5, 120)];
        [self addSubview:vShow2];
        
        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
        [vShow2 addGestureRecognizer:tap2];
        
        
        vShow3 = [[HomeOrderShowView alloc] initWithFrame:CGRectMake(mainWidth/2+5, 130, mainWidth / 2 - 5, 120)];
        [self addSubview:vShow3];
        
        UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction3)];
        [vShow3 addGestureRecognizer:tap3];
    }
    return self;
}

- (void)setOrderShows
{
    if([HomeInstance ShardInstnce].listOrderShows)
    {
        [vShow1 setOrderShow:[[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:0]];
        [vShow2 setOrderShow:[[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:1]];
        [vShow3 setOrderShow:[[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:2]];
    }
}

- (void)tapAction1
{
    HomeOrderShowItem* item = [[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:0];
    [delegate doCickShare:[item.postID intValue]];
}

- (void)tapAction2
{
    HomeOrderShowItem* item = [[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:1];
    [delegate doCickShare:[item.postID intValue]];
}

- (void)tapAction3
{
    HomeOrderShowItem* item = [[HomeInstance ShardInstnce].listOrderShows.listItems objectAtIndex:2];
    [delegate doCickShare:[item.postID intValue]];
}

@end
