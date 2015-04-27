//
//  OneBaseVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "OneBaseVC.h"
#import "BaseNoDataView.h"
#import "BaseLoadView.h"
#import "CartInstance.h"

@interface OneBaseVC ()<UIGestureRecognizerDelegate>
{
    BaseNoDataView      *viewEmpty;
    BaseLoadView        *viewLoad;
}
@end

@implementation OneBaseVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger count = self.navigationController.viewControllers.count;
    self.navigationController.interactivePopGestureRecognizer.enabled = count > 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCartAnimation:) name:kDidAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCartAnimation2:) name:kDidAddCartSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCartAnimation3:) name:kDidAddCartOpt object:nil];
    
    
    viewEmpty = [[BaseNoDataView alloc] initWithFrame:self.view.bounds];
    viewLoad = [[BaseLoadView alloc] initWithFrame:self.view.bounds];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - addcart
- (void)addCartAnimation:(NSNotification*)obj
{
    UIImageView* sourceView = (UIImageView*)obj.object;
    [self addCartAn:addCartType_Tab sourceView:sourceView];
}

- (void)addCartAnimation2:(NSNotification*)obj
{
    UIImageView* sourceView = (UIImageView*)obj.object;
    [self addCartAn:addCartType_Search sourceView:sourceView];
}

- (void)addCartAnimation3:(NSNotification*)obj
{
    UIImageView* sourceView = (UIImageView*)obj.object;
    [self addCartAn:addCartType_Opt sourceView:sourceView];
}

- (void)addCartAn:(int)type sourceView:(UIImageView*)sourceView
{
    if(!sourceView)
        return;
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (__bridge id)(sourceView.image.CGImage);
    layer.frame = CGRectMake(-sourceView.frame.size.width, -sourceView.frame.size.height, sourceView.frame.size.width, sourceView.frame.size.height);
    layer.cornerRadius = sourceView.frame.size.width / 2;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.masksToBounds = YES;
    layer.opacity = 1;
    [self.view.window.layer addSublayer:layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint pt;
    pt.x = CGRectGetMidX(sourceView.bounds);
    pt.y = CGRectGetMidY(sourceView.bounds);
    CGPoint startPoint = [sourceView convertPoint:pt toView:self.view.window];
    [path moveToPoint:startPoint];
    CGPoint endPoint;
    if(type == addCartType_Tab)
        endPoint = CGPointMake(mainWidth*3/5 + 35, mainHeight-10);
    else if (type == addCartType_Search)
        endPoint = CGPointMake(mainWidth - 70, mainHeight-30);
    else if (type == addCartType_Opt)
        endPoint = CGPointMake(mainWidth - 30, mainHeight-10);
    CGPoint controlPoint = CGPointMake(endPoint.x, startPoint.y);
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    CAKeyframeAnimation *animationPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationPosition.path = path.CGPath;
    animationPosition.removedOnCompletion = YES;
    animationPosition.fillMode = kCAFillModeForwards;
    animationPosition.autoreverses = NO;
    animationPosition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animationSize = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationSize.fromValue = @1;
    animationSize.toValue = @0.05;
    animationSize.removedOnCompletion = YES;
    animationSize.fillMode = kCAFillModeForwards;
    animationSize.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = 1.0f;
    animationGroup.animations = @[animationPosition, animationSize];
    animationGroup.delegate = self;
    [animationGroup setValue:layer forKey:@"parentLayer"];
    [layer addAnimation:animationGroup forKey:@"addCart"];
}

#pragma mark - Empty
- (void)showEmpty
{
    viewEmpty.frame = self.view.bounds;
    [self.view addSubview:viewEmpty];
}

- (void)showEmpty:(CGRect)frame
{
    viewEmpty.frame = frame;
    [self.view addSubview:viewEmpty];
}

- (void)hideEmpty
{
    [viewEmpty removeFromSuperview];
}
#pragma mark - load
- (void)showLoad
{
    viewLoad.frame = self.view.bounds;
    [self.view addSubview:viewLoad];
}
- (void)hideLoad
{
    [viewLoad removeFromSuperview];
}
@end
