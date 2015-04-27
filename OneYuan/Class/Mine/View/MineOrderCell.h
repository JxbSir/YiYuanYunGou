//
//  MineOrderCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderModel.h"

@protocol MineMyOrderCellDelegate <NSObject>
- (void)confirmOrder:(int)orderId;
- (void)confirmShip:(int)orderId;
@end

@interface MineOrderCell : UITableViewCell
@property(nonatomic,weak)id<MineMyOrderCellDelegate> delegate;
- (void)setMyOrder:(MineMyOrderItem*)item;
@end
