//
//  MineUserView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineUserViewDelegate <NSObject>
- (void)btnPayAction;
@end

@interface MineUserView : UIView
@property(nonatomic,weak)id<MineUserViewDelegate> delegate;
@end
