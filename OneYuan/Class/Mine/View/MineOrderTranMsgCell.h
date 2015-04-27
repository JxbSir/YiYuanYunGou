//
//  MineOrderTranMsgCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyOrderTransModel.h"

@interface MineOrderTranMsgCell : UITableViewCell

- (void)setTrans:(MineMyOrderTransInfo*)info index:(int)index last:(BOOL)last;
@end
