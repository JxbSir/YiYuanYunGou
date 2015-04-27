//
//  UIButton+IndexPath.h
//  Surfboard
//
//  Created by Moshe on 8/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (IndexPath)

/**
 *  Sets the button's index path.
 *
 *  @param indexPath The index path to set.
 */

- (void)setIndexPath:(NSIndexPath *)indexPath;

/**
 *  Retrieve the button's indexPath.
 *
 *  @return The indexPath on the button.
 */

- (NSIndexPath *)indexPath;


@end
