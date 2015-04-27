//
//  AllProTypeView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllProTypeViewDelegate
- (void)selectedTypeCode:(int)code;
@end

@interface AllProTypeView : UIView
@property(nonatomic,weak)id<AllProTypeViewDelegate> delegate;
@end
