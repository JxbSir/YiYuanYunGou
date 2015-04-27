//
//  HomeNewingView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol HomeNewingViewDelegate <NSObject>
- (void)doClickGoods:(int)goodsId codeId:(int)codeId;
@end

@interface HomeNewingView : UIView
@property(nonatomic,weak)id<HomeNewingViewDelegate> delegate;;
- (void)setNewing:(HomeNewing*)newing;
@end
