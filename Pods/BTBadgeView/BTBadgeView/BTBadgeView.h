//
//  BTBadgeView.h
//
//  Version 1.2
//
//  Created by Borut Tomazin on 12/04/2013.
//  Copyright 2013 Borut Tomazin
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/borut-t/BTBadgeView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <UIKit/UIKit.h>

@interface BTBadgeView : UIView

/**
 The current value displayed in the badge. Updating the value will update the view's display.
 */
@property (nonatomic,copy) NSString *value;

/**
 Indicates whether the badge view draws a shadow or not.
 */
@property (nonatomic,assign) BOOL shadow;

/**
 (Optional) The offset for the shadow.
 */
@property (nonatomic,assign) CGSize shadowOffset;

/**
 (Optional) The base color for the shadow.
 */
@property (nonatomic,strong) UIColor *shadowColor;

/**
 Indicates whether the badge view should be drawn with a shine.
 */
@property (nonatomic,assign) BOOL shine;

/**
 The font to be used for drawing the numbers. NOTE: Only "system fonts" should be used.
 */
@property (nonatomic,strong) UIFont *font;

/**
 The color used for the background of the badge.
 */
@property (nonatomic,strong) UIColor *fillColor;

/**
 The color to be used for drawing the stroke around the badge.
 */
@property (nonatomic,strong) UIColor *strokeColor;

/**
 The width for the stroke around the badge.
 */
@property (nonatomic,assign) CGFloat strokeWidth;

/**
 The color to be used for drawing the badge's numbers.
 */
@property (nonatomic,strong) UIColor *textColor;

/**
 If YES, the badge will be hidden when the value is 0 or empty string.
 */
@property (nonatomic,assign) BOOL hideWhenEmpty;

@end
