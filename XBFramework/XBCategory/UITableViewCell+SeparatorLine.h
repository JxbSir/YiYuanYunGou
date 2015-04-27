//
//  UITableViewCell+SeparatorLine.h
//  QuicklyShop
//
//  Created by 宋涛 on 14/7/12.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SeparatorType)
{
    SeparatorTypeHead    =   1,
    SeparatorTypeMiddle      ,
    SeparatorTypeBottom      ,
    SeparatorTypeSingle,
    SeparatorTypeShort,
};


@interface UITableViewCell (SeparatorLine)

- (void)addSeparatorLineWithType:(SeparatorType)separatorType;

@end
