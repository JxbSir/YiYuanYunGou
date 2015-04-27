//
//  OneBaseVC.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneBaseVC : XBBaseVC

- (void)addCartAnimation:(UIImageView*)sourceView;

#pragma mark - Empty
- (void)showEmpty;
- (void)showEmpty:(CGRect)frame;
- (void)hideEmpty;

#pragma mark - load
- (void)showLoad;
- (void)hideLoad;
@end
