//
//  IPDashedLineView.m
//  IPDashedLine
//
//  Created by Colin Brash on 5/30/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "IPDashedLineView.h"

@implementation IPDashedLineView

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
    _direction = IPDashedLineViewDirectionAutomatic;
    _phase = 0;
    _lineColor = [UIColor blackColor];
    _lengthPattern = @[@2, @2];
}

#pragma mark -

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    IPDashedLineViewDirection direction = self.direction;
    
    BOOL isVertical = (self.direction == IPDashedLineViewDirectionVerticalFromTop || self.direction == IPDashedLineViewDirectionVerticalFromBottom);
    if (direction == IPDashedLineViewDirectionAutomatic) {
        isVertical = (rect.size.height > rect.size.width);
        direction = (isVertical ? IPDashedLineViewDirectionVerticalFromTop : IPDashedLineViewDirectionHorizontalFromLeft);
    }
    
    CGFloat borderWidth = (isVertical ? rect.size.width : rect.size.height) * [UIScreen mainScreen].scale;
    
    CGPoint startPoint;
    CGPoint endPoint;
    switch (direction) {
        case IPDashedLineViewDirectionHorizontalFromLeft:
            startPoint = CGPointMake(rect.origin.x, rect.origin.y);
            endPoint = CGPointMake(CGRectGetMaxX(rect), rect.origin.y);
            break;
        case IPDashedLineViewDirectionHorizontalFromRight:
            startPoint = CGPointMake(CGRectGetMaxX(rect), rect.origin.y);
            endPoint = CGPointMake(rect.origin.x, rect.origin.y);
            break;
        case IPDashedLineViewDirectionVerticalFromTop:
            startPoint = CGPointMake(rect.origin.x, rect.origin.y);
            endPoint = CGPointMake(rect.origin.x, CGRectGetMaxY(rect));
            break;
        case IPDashedLineViewDirectionVerticalFromBottom:
            startPoint = CGPointMake(rect.origin.x, CGRectGetMaxY(rect));
            endPoint = CGPointMake(rect.origin.x, rect.origin.y);
            break;
            
        default:
            startPoint = CGPointMake(rect.origin.x, rect.origin.y);
            endPoint = CGPointMake(rect.origin.x, rect.origin.y);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    int count = (int)[self.lengthPattern count];
    CGFloat cArrayLengthPattern[count];
    for (int i = 0; i < count; ++i) {
        cArrayLengthPattern[i] = (CGFloat)[self.lengthPattern[i] floatValue];
    }

    CGContextSetLineDash(context, self.phase, cArrayLengthPattern, count);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

@end
