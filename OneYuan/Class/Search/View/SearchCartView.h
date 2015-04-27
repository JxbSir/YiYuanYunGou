//
//  SearchCartView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCartViewDelegate <NSObject>
- (void)gotoCart;
@end

@interface SearchCartView : UIView
@property(nonatomic,weak)id<SearchCartViewDelegate> delegate;
-(void)setCartNum:(int)count;
@end
