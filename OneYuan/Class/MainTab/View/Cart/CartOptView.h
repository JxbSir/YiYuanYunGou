//
//  CartOptView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartOptViewDelegate <NSObject>
- (void)cartCalcAction;
@end

@interface CartOptView : UIView
@property(nonatomic,weak)id<CartOptViewDelegate> delegate;
- (void)setOpt;
@end
