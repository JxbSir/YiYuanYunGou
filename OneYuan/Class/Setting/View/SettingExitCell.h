//
//  SettingExitCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingExitCellDelegate <NSObject>
- (void)btnExitClick;
@end

@interface SettingExitCell : UITableViewCell
@property(nonatomic,weak)id<SettingExitCellDelegate> delegate;
@end
