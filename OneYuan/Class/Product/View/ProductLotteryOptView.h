//
//  ProductLotteryOptView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"

@protocol ProductLotteryOptViewDelegate <NSObject>
-(void)gotoDetailAction;
-(void)gotoCartAction;
@end

@interface ProductLotteryOptView : UIView
@property(nonatomic,weak)id<ProductLotteryOptViewDelegate> delegate;
- (void)setBtnPeriod:(AllProPeriod*)period;
@end
