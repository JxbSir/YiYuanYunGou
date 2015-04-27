//
//  HomeNewCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeNewCell.h"
#import "HomeNewIngOrEndView.h"


@interface HomeNewCell ()<HomeNewIngOrEndViewDelegate>
{
    __weak id<HomeNewCellDelegate> delegate;
    HomeNewIngOrEndView *view1;
    HomeNewIngOrEndView *view2;
    HomeNewIngOrEndView *view3;
    HomeNewIngOrEndView *view4;
}

@end

@implementation HomeNewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
      
        view1 = [[HomeNewIngOrEndView alloc] initWithFrame:CGRectMake(0, 0, mainWidth / 2, 70)];
        view1.delegate = self;
        [self addSubview:view1];
    
        view2 = [[HomeNewIngOrEndView alloc] initWithFrame:CGRectMake(mainWidth / 2, 0, mainWidth / 2, 70)];
        view2.delegate = self;
       [self addSubview:view2];
        
        view3 = [[HomeNewIngOrEndView alloc] initWithFrame:CGRectMake(0, 70, mainWidth / 2, 70)];
        view3.delegate = self;
        [self addSubview:view3];
   
        view4 = [[HomeNewIngOrEndView alloc] initWithFrame:CGRectMake(mainWidth / 2, 70, mainWidth / 2, 70)];
        view4.delegate = self;
        [self addSubview:view4];

    }
    return self;
}

- (void)setNews:(HomeNewingList*)listNewing homepage:(NSArray*)listHomepage
{
    if(!listNewing)
    {
        [view1 setNewLoad];
        [view2 setNewLoad];
        [view3 setNewLoad];
        [view4 setNewLoad];
        return;
    }
    if (listNewing.listItems.count > 0)
    {
        for (int i = 0; i<listNewing.listItems.count;i++) {
            if(i == 0)
            {
                [view1 setNewing:[listNewing.listItems objectAtIndex:i]];
            }
            else if(i == 1)
            {
                [view2 setNewing:[listNewing.listItems objectAtIndex:i]];
            }
            else if(i == 2)
            {
                [view3 setNewing:[listNewing.listItems objectAtIndex:i]];
            }
            else if(i == 3)
            {
                [view4 setNewing:[listNewing.listItems objectAtIndex:i]];
            }
        }
    }
    int newCount = (int)listNewing.listItems.count;
    int leftCount = 4 - newCount;
    for(int i =0;i<leftCount;i++)
    {
        int location = newCount + i;
        if(location == 0)
        {
            [view1 setNewed:[listHomepage objectAtIndex:i]];
        }
        else if(location == 1)
        {
            [view2 setNewed:[listHomepage objectAtIndex:i]];
        }
        else if(location == 2)
        {
            [view3 setNewed:[listHomepage objectAtIndex:i]];
        }
        else if(location == 3)
        {
            [view4 setNewed:[listHomepage objectAtIndex:i]];
        }
    }
}

#pragma mark - delegate
- (void)doClickGoods:(int)goodsId codeId:(int)codeId
{
    if(delegate)
    {
        [delegate doClickGoods:goodsId codeId:codeId];
    }
}
@end
