//
//  IPDashedBorderedView.m
//  IPDashedLine
//
//  Created by Colin Brash on 6/27/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "IPDashedBorderedView.h"

@implementation IPDashedBorderedView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _phase = 0.0;
    _lineColor = [UIColor blackColor];
    _lengthPattern = @[@2, @2];
    _borderWidth = 1.0;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.borderWidth * [UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    int count = (int)[self.lengthPattern count];
    CGFloat cArrayLengthPattern[count];
    for (int i = 0; i < count; ++i) {
        cArrayLengthPattern[i] = (CGFloat)[self.lengthPattern[i] floatValue];
    }
    
    CGContextSetLineDash(context, self.phase, cArrayLengthPattern, count);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), rect.origin.y);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, rect.origin.x, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
    CGContextStrokePath(context);
}


@end
