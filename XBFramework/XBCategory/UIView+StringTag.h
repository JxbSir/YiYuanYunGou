//
//  UIView+StringTag.h
//  AppAustriaX
//
//  Created by 梵天 on 14-7-4.
//  Copyright (c) 2014年 Austria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StringTag)

@property (nonatomic, strong) NSString *stringTag;

- (UIView *)viewWithStringTag:(NSString *)tag;

- (UIView *)findFirstResponder;

@end