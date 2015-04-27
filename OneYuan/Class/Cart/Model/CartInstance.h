//
//  CartInstance.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartModel.h"

typedef enum
{
    addCartType_Tab,
    addCartType_Search,
    addCartType_Opt
}addCartType;

@interface CartInstance : NSObject

+(CartInstance*)ShartInstance;

- (void)addToCart:(CartItem*)item imgPro:(UIImageView*)imgPro type:(addCartType)type;
@end
