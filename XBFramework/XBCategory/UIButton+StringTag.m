//
//  UIButton+StringTag.m
//  Jxb_Sdk
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/27.
//  Copyright (c) 2015年 Peter Jin. All rights reserved.
//

#import "UIButton+StringTag.h"

#import <objc/runtime.h>

static char viewStringTag;
static char viewStringTag2;
static char viewStringTag3;

@implementation UIButton (StringTag)

- (void)setStringTag:(NSString *)stringTag{
    
    objc_setAssociatedObject(self, &viewStringTag, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag{
    
    return objc_getAssociatedObject(self, &viewStringTag);
}

- (void)setStringTag2:(NSString *)stringTag{
    
    objc_setAssociatedObject(self, &viewStringTag2, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag2{
    
    return objc_getAssociatedObject(self, &viewStringTag2);
}

- (void)setStringTag3:(NSString *)stringTag{
    
    objc_setAssociatedObject(self, &viewStringTag3, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag3{
    
    return objc_getAssociatedObject(self, &viewStringTag3);
}

@end
