//
//  SVPullToRefreshView+OY_PullRefreshView.m
//  TZS
//
//  Created by Peter Jin (https://github.com/JxbSir) on  14-12-22.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import "SVPullToRefreshView+OY_PullRefreshView.h"
#import <objc/runtime.h>

static const NSInteger kStripViewTag = 1;

@implementation OYSVCustomView

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end

@implementation OYSVActivityIndicatorView

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void)startAnimating
{
    [super startAnimating];
}

- (void)stopAnimating
{
    [super stopAnimating];
}
@end

@implementation OYSVLabel

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
}
@end

@implementation SVPullToRefreshView (OY_PullRefreshView)
@dynamic oyCustomView,indicator,lblInfo,isLoading;

- (OYSVCustomView *)oyCustomView
{
    return objc_getAssociatedObject(self, @"oyImageView");
}

- (void)setTzsCustomView:(OYSVCustomView *)oyCustomView
{
    objc_setAssociatedObject(self, @"oyImageView", oyCustomView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (OYSVLabel *)lblInfo
{
    return objc_getAssociatedObject(self, @"lblinfo");
}

- (void)setLblInfo:(OYSVLabel *)lblInfo
{
    objc_setAssociatedObject(self, @"lblinfo", lblInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isLoading
{
    return [objc_getAssociatedObject(self, @"loading") boolValue];
}

- (void)setIsLoading:(BOOL)isLoading
{
    objc_setAssociatedObject(self, @"loading", [NSNumber numberWithBool:isLoading], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setOYStyle
{
    [self setTitle:@"" forState:SVPullToRefreshStateAll];
    [self setTitle:@"" forState:SVPullToRefreshStateLoading];
    [self setSubtitle:@"" forState:SVPullToRefreshStateAll];
    self.tzsCustomView = [[OYSVCustomView alloc] initWithImage:[UIImage imageNamed:@"yyg_center"]];
    
    for (UIView *v in self.subviews) {
        NSString* className = [NSString stringWithFormat:@"%@",[v class]];
        if ([className isEqualToString:@"SVPullToRefreshArrow"])
        {
            [v removeFromSuperview];
        }
        else if ([className isEqualToString:@"UIImageView"])
        {
            [v removeFromSuperview];
        }
        else if ([className isEqualToString:@"UIActivityIndicatorView"])
        {
            UIActivityIndicatorView* indict = (UIActivityIndicatorView*)v;
            indict.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [indict removeFromSuperview];
        }
    }
    
    if (self.oyCustomView)
    {
        UIView *frameView = [[UIView alloc] init];
        [self addSubview:frameView];
        
        self.oyCustomView.frame = CGRectMake(35, 0, 30, 30);
        [frameView addSubview:self.oyCustomView];
        
        UIImageView *stripView = [[UIImageView alloc] init];
        stripView.tag = kStripViewTag;
        stripView.image = [UIImage imageNamed:@"yyg_around"];
        //stripView.backgroundColor = BG_COLOR;
        stripView.layer.position = self.oyCustomView.center;
        stripView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        stripView.layer.bounds = CGRectMake(0, 0, 35, 35);
        stripView.layer.transform = CATransform3DRotate(stripView.layer.transform, -M_PI/10, 0, 0, 1);
        [frameView addSubview:stripView];
        
//        self.lblInfo = [[OYSVLabel alloc] init];
//        [self.lblInfo setFont:[UIFont systemFontOfSize:12]];
//        [self.lblInfo setTextColor:[UIColor hexFloatColor:@"c7c7c7"]];
//        [self.lblInfo setFrame:CGRectMake(25, 6, 200, 13)];
//        [frameView addSubview:self.lblInfo];
        
        CGRect unionFrame = CGRectUnion(self.oyCustomView.frame, self.lblInfo.frame);
        frameView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[frameView(width)]" options:0 metrics:@{@"width":@(CGRectGetWidth(unionFrame))} views:NSDictionaryOfVariableBindings(frameView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[frameView(height)]" options:0 metrics:@{@"height":@(CGRectGetHeight(unionFrame))} views:NSDictionaryOfVariableBindings(frameView)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:frameView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-50]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:frameView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *v in self.subviews) {
        NSString* className = [NSString stringWithFormat:@"%@",[v class]];
        if ([className isEqualToString:@"SVPullToRefreshArrow"])
        {
            [v removeFromSuperview];
        }
    }
    
    self.titleLabel.hidden = YES;
    self.subtitleLabel.hidden = YES;

    SVPullToRefreshState nowState = self.state;
    switch (nowState) {
        case SVPullToRefreshStateStopped:
        {
            [self stopAnimatingCustomView];
        }
            break;
        case SVPullToRefreshStateTriggered:
        {
            [self startAnimatingCustomView];
        }
            break;
        case SVPullToRefreshStateLoading:
        {
            [self startAnimatingCustomView];
        }
            break;
        case SVPullToRefreshStateAll:
        {
            NSLog(@"all");
        }
            break;
        default:
            break;
    }
}

- (UIView *)stripViewInCustomView {
    UIView* v = [self.oyCustomView.superview viewWithTag:kStripViewTag];
    return v;
}

- (void)startAnimatingCustomView {
    if (![self.oyCustomView.layer.animationKeys containsObject:@"rotateAnimation"]) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.byValue = @(M_PI*2);
        rotateAnimation.duration = 0.8;
        [[self stripViewInCustomView].layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
}

- (void)stopAnimatingCustomView {
    [[self stripViewInCustomView].layer removeAllAnimations];
}
@end
