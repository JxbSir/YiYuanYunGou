//
//  CartInstance.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "CartInstance.h"
#import "AppDelegate.h"

@implementation CartInstance

+(CartInstance*)ShartInstance
{
    static CartInstance* _cart = nil;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        _cart = [[CartInstance alloc] init];
    });
    return _cart;
}

- (void)addToCart:(CartItem*)item imgPro:(UIImageView*)imgPro type:(addCartType)type
{
    __block CartItem* tmpItem = item;
    [CartModel quertCart:@"cPid" value:item.cPid block:^(NSArray* result)
     {
         if(result.count > 0)
         {
             tmpItem.cBuyNum = [NSNumber numberWithInt:[[[result objectAtIndex:0] cBuyNum] intValue] + 1];
         }
         [CartModel addorUpdateCart:tmpItem];
     }];
    
    if(type == addCartType_Tab)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCart object:imgPro];
    }
    if(type == addCartType_Search)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCartSearch object:imgPro];
    }
    else if(type == addCartType_Opt)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCartOpt object:imgPro];
    }
    
    [self performSelector:@selector(setCartNum) withObject:self afterDelay:1];

}


- (void)setCartNum
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
}
@end
