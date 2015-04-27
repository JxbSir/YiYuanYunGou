//
//  ProductDetailOptView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDetailOptViewDelegate <NSObject>
- (void)addToCartAction;
- (void)addGotoCartAction;
- (void)gotoCartAction;
@end

@interface ProductDetailOptView : UIView
@property(nonatomic,weak)id<ProductDetailOptViewDelegate> delegate;

- (void)setCartNum:(int)count;
@end
