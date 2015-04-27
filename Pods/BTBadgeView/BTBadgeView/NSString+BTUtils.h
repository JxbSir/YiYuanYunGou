//
//  NSString+BTUtils.h
//
//  Version 1.3
//
//  Created by Borut Tomazin on 8/30/2013.
//  Copyright 2013 Borut Tomazin
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/borut-t/BTUtils
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

#ifdef __IPHONE_6_0
    #define UILineBreakModeWordWrap NSLineBreakByWordWrapping
#endif

@interface NSString (BTUtils)

/**
 Trims leading and trailing whitespaces from given string.
 */
- (NSString *)trim;

/**
 Returns text bounds size for specified text in predicted field.
 
 @param text A text to calculate bounds from.
 @param font A font to apply to text.
 @param size A bounds field size.
 */
- (CGSize)textSizeWithFont:(UIFont *)font fieldSize:(CGSize)size;

@end
