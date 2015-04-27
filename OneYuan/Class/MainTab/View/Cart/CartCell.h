//
//  CartCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

@protocol CartCellDelegate
- (void)setOpt;
@end

@interface CartCell : UITableViewCell
@property(nonatomic,weak)id<CartCellDelegate> delegate;
- (void)setCart:(CartItem*)item;
@end
