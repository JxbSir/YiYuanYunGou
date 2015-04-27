//
//  HomeAdDigitalCell.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAdDigitalCellDelegate
- (void)adClick:(NSString*)key;
@end

@interface HomeAdDigitalCell : UITableViewCell
@property(nonatomic,weak)id<HomeAdDigitalCellDelegate> delegate;
- (void)doLoadAds;
@end
