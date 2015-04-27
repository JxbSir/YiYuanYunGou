//
//  NSString+Size.h
//  TZS
//
//  Created by Peter Jin (https://github.com/JxbSir) on  14-12-17.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
