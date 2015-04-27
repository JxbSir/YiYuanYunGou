//
//  AllProItemCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"

typedef enum
{
    ProCellType_All,
    ProCellType_Search
}ProCellType;

@interface AllProItemCell : UITableViewCell

- (void)setProItem:(AllProItme*)item type:(ProCellType)type;
@end
