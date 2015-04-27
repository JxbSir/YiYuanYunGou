//
//  MineMyAddItemCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyAddressModel.h"

@protocol MineMyAddItemCellDelegate <NSObject>
- (void)setDefault:(int)addressId;
@end


@interface MineMyAddItemCell : UITableViewCell
@property(nonatomic,weak)id<MineMyAddItemCellDelegate> delegate;
- (void)setAddress:(MineMyAddressItem*)item bShow:(BOOL)bShow;
@end
