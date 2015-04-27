//
//  AllProView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllProViewDelegate <NSObject>
- (void)doClickProduct:(int)goodsId;
@end

@interface AllProView : UIView
@property(nonatomic,assign)int proType;
@property(nonatomic,weak)id<AllProViewDelegate> delegate;
- (id)initWithOrder:(CGRect)frame indexOrder:(int)indexOrder;
- (void)setTypeAndOrder:(int)type sort:(int)sort;
@end
