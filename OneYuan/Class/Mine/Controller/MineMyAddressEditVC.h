//
//  MineMyAddressEditVC.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMyAddressModel.h"

@protocol MineMyAddressEditVCDelegate <NSObject>

-(void)refreshAddress;

@end

@interface MineMyAddressEditVC : OneBaseVC
@property(nonatomic,weak)id<MineMyAddressEditVCDelegate> delegate;
- (id)initWithAddress:(MineMyAddressItem*)item;
@end
