//
//  HomeNewIngOrEndView.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol HomeNewIngOrEndViewDelegate <NSObject>
- (void)doClickGoods:(int)goodsId codeId:(int)codeId;
@end

@interface HomeNewIngOrEndView : UIView
@property(nonatomic,weak)id<HomeNewIngOrEndViewDelegate> delegate;

- (void)setNewLoad;
- (void)setNewing:(HomeNewing*)newing;
- (void)setNewed:(HomeNewed*)newed;
@end
