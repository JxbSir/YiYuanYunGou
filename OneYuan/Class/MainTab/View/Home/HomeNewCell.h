//
//  HomeNewCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol HomeNewCellDelegate <NSObject>
- (void)doClickGoods:(int)goodsId codeId:(int)codeId;
@end

@interface HomeNewCell : UITableViewCell
@property(nonatomic,weak)id<HomeNewCellDelegate> delegate;
- (void)setNews:(HomeNewingList*)listNewing homepage:(NSArray*)listHomepage;
@end
