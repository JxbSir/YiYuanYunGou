//
//  MineMyAddressVC.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MineAddressType_Common,
    MineAddressType_Select
}MineAddressType;

@protocol MineMyAddressVCDelegate <NSObject>
- (void)refreshMyOrder;
@end

@interface MineMyAddressVC : OneBaseVC
@property(nonatomic,weak)id<MineMyAddressVCDelegate> delegate;
- (id)initWithType:(MineAddressType)type orderId:(int)orderId;
@end
