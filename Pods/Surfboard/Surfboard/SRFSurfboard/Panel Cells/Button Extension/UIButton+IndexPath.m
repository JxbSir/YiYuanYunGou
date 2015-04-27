//
//  UIButton+IndexPath.m
//  Surfboard
//
//  Created by Moshe on 8/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "UIButton+IndexPath.h"
#import <objc/runtime.h>

/**
 *
 */

static const char *kPropertyKeyIndexPath = "com.mosheberman.indexPath";

/**
 *
 */
@implementation UIButton (IndexPath)

/**
 *  Sets the button's index path.
 *
 *  @param indexPath The index path to set.
 */

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, kPropertyKeyIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  Retrieve the button's indexPath.
 *
 *  @return The indexPath on the button.
 */

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, kPropertyKeyIndexPath);
}

@end
