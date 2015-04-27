//
//  UIImageView+DotLine.m
//  Jxb_Sdk
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/3.
//  Copyright (c) 2015年 Peter Jin. All rights reserved.
//

#import "UIImageView+DotLine.h"

@implementation UIImageView (DotLine)

- (void)drawRect:(CGRect)rect
{
    [self drawLine];
}

-(void)drawLine
{
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.创建可变的路径并设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    //1）设置起始点
    CGPathMoveToPoint(path, NULL, 65, 215);
    //2）设置目标点
    CGPathAddLineToPoint(path, NULL, 115, 220);
    //3.将路径添加到上下文
    CGContextAddPath(context, path);
    //4.设置上下文属性
    /**
     kCGPathStroke:      画线 (空心）
     kCGPathFill:        填充 (实心)
     kCGPathFillStroke:  即画线又填充
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //5.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    //6.释放 路径
    CGPathRelease(path);
}
@end
