//
//  UITableViewCell+SeparatorLine.m
//  QuicklyShop
//
//  Created by 宋涛 on 14/7/12.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "UITableViewCell+SeparatorLine.h"

#define kTopTag      @"topSeparatorTag"
#define kBottomTag   @"bottomSeparatorTag"
#define color_image  [UIImage imageWithRenderColor:[UIColor hexFloatColor:@"e3e0de"] renderSize:CGSizeMake(1., 1.)]

@implementation UITableViewCell (SeparatorLine)
- (void)addSeparatorLineWithType:(SeparatorType)separatorType {
    UIImageView *topImageView = (UIImageView *)[self viewWithStringTag:kTopTag];
    UIImageView *bottomImageView = (UIImageView *)[self viewWithStringTag:kBottomTag];
    
    CGFloat separatorInset   = (separatorType == SeparatorTypeBottom || separatorType == SeparatorTypeSingle)?0:15;
    separatorInset = (separatorType == SeparatorTypeShort ? 58 : separatorInset);
    BOOL showTopSeparator = (separatorType == SeparatorTypeHead   || separatorType == SeparatorTypeSingle)?YES:NO;
    
    if (showTopSeparator) {
        if (!topImageView) {
            topImageView = [[UIImageView alloc] init];
            topImageView.stringTag = kTopTag;
            topImageView.image = color_image;
            topImageView.highlightedImage = color_image;
        }
        topImageView.frame = CGRectMake(0, 0,CGRectGetWidth(self.frame), .5);
        [self addSubview:topImageView];
    } else {
        if (topImageView) {
            [topImageView removeFromSuperview];
        }
    }
    
    if (!bottomImageView) {
        bottomImageView = [[UIImageView alloc] init];
        bottomImageView.stringTag = kBottomTag;
        bottomImageView.image = color_image;
        bottomImageView.highlightedImage = color_image;
    }
    
    [bottomImageView setFrame:CGRectMake(separatorInset, CGRectGetHeight(self.bounds)-0.5, CGRectGetWidth(self.bounds), .5)];
    [self addSubview:bottomImageView];
}

@end
