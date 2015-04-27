//
//  NSString+BTUtils.m
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

#import "NSString+BTUtils.h"

@implementation NSString (BTUtils)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)textSizeWithFont:(UIFont *)font fieldSize:(CGSize)size;
{
    if (self == nil || [self trim].length == 0) {
        return CGSizeZero;
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGSize boundingBox = [self boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size;
        return CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else {
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        #pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
}

@end
