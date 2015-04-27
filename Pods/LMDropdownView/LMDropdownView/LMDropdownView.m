//
//  LMDropdownView.m
//  LMDropdownView
//
//  Created by LMinh on 16/11/2014.
//  Copyright (c) Năm 2014 LMinh. All rights reserved.
//

#import "LMDropdownView.h"
#import "UIImage+LMImage.h"

#define kDefaultBounceHeight                30
#define kDefaultAnimationDuration           0.5
#define kDefaultDepthStyleClosedScale       0.85
#define kDefaultBlurRadius                  5
#define kDefaultBlackMaskAlpha              0.5

@interface LMDropdownView ()
{
    CGPoint originMenuCenter;
    CGPoint desMenuCenter;
}
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIButton *backgroundButton;

@end

@implementation LMDropdownView

#pragma mark - INIT

- (id)init
{
    self = [super init];
    if (self) {
        _animationDuration = kDefaultAnimationDuration;
        _closedScale = kDefaultDepthStyleClosedScale;
        _blurRadius = kDefaultBlurRadius;
        _blackMaskAlpha = kDefaultBlackMaskAlpha;
        
        _currentState = LMDropdownViewStateDidClose;
    }
    return self;
}


#pragma mark - PUBLIC METHOD

- (BOOL)isOpen
{
    return (_currentState == LMDropdownViewStateDidOpen);
}

- (void)showInView:(UIView *)view withFrame:(CGRect)frame
{
    if (_currentState == LMDropdownViewStateDidClose)
    {
        _currentState = LMDropdownViewStateWillOpen;
        
        // Setup menu in view
        [self setupMenuInView:view withFrame:frame];
        
        // Animate menu view controller
        [self addMenuAnimationForMenuState:_currentState];
        
        // Animate content view controller
        [self addContentAnimationForMenuState:_currentState];
        
        // Finish showing
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _currentState = LMDropdownViewStateDidOpen;
        });
    }
}

- (void)hide
{
    if (_currentState == LMDropdownViewStateDidOpen)
    {
        _currentState = LMDropdownViewStateWillClose;
        
        // Animate menu view controller
        [self addMenuAnimationForMenuState:_currentState];
        
        // Animate content view controller
        [self addContentAnimationForMenuState:_currentState];
        
        // Finish hiding
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.menuView removeFromSuperview];
            [self.backgroundButton removeFromSuperview];
            [self.contentView removeFromSuperview];
            [self.mainView removeFromSuperview];
            
            _currentState = LMDropdownViewStateDidClose;
        });
    }
}


#pragma mark - PRIVATE

- (void)setupMenuInView:(UIView *)view withFrame:(CGRect)frame
{
    // Prepare content image
    CGSize contentSize = [view bounds].size;
    CGSize capturedSize = CGSizeMake(contentSize.width * (3 - 2 * self.closedScale), contentSize.height * (3 - 2 * self.closedScale));
    UIImage *capturedImage = [UIImage imageFromView:view withSize:capturedSize];
    UIImage *blurredCapturedImage = [capturedImage blurredImageWithRadius:self.blurRadius iterations:5 tintColor:[UIColor clearColor]];
    
    
    // Main View
    if (!self.mainView) {
        self.mainView = [[UIScrollView alloc] init];
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    [self.mainView setFrame:frame];
    [view addSubview:self.mainView];
    
    
    // Content Image View
    if (!self.contentView) {
        self.contentView = [[UIImageView alloc] init];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.contentView.contentMode = UIViewContentModeCenter;
    }
    self.contentView.image = blurredCapturedImage;
    [self.contentView setFrame:CGRectMake(-contentSize.width * (1 - self.closedScale),
                                          -self.mainView.frame.origin.y - contentSize.height * (1 - self.closedScale),
                                          contentSize.width * (3 - 2 * self.closedScale),
                                          contentSize.height * (3 - 2 * self.closedScale))];
    [self.mainView addSubview:self.contentView];
    
    
    // Background Button
    if (!self.backgroundButton) {
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.blackMaskAlpha];
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.backgroundButton setFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    [self.mainView addSubview:self.backgroundButton];
    
    
    // Menu Table View
    if (!self.menuView) {
        self.menuView = [[UIView alloc] init];
    }
    self.menuView.backgroundColor = self.menuBackgroundColor;
    [self.menuContentView setFrame:CGRectMake(0, kDefaultBounceHeight, self.menuContentView.bounds.size.width, self.menuContentView.bounds.size.height)];
    [self.menuView addSubview:self.menuContentView];
    
    CGFloat menuTableViewHeight = MIN(self.menuContentView.bounds.size.height + kDefaultBounceHeight, self.mainView.bounds.size.height);
    [self.menuView setFrame:CGRectMake(0, -menuTableViewHeight, self.mainView.bounds.size.width, menuTableViewHeight)];
    [self.mainView addSubview:self.menuView];
    
    originMenuCenter = CGPointMake(self.menuView.bounds.size.width/2, -self.menuView.bounds.size.height/2);
    desMenuCenter = CGPointMake(self.menuView.bounds.size.width/2, self.menuView.bounds.size.height/2 - kDefaultBounceHeight);
}

- (void)backgroundButtonTapped:(id)sender
{
    [self hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewDidTapBackgroundButton:)]) {
            [self.delegate dropdownViewDidTapBackgroundButton:self];
        }
    });
}


#pragma mark - KEYFRAME ANIMATION

- (void)addMenuAnimationForMenuState:(LMDropdownViewState)state
{
    CAKeyframeAnimation *menuBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    menuBounceAnim.duration = self.animationDuration;
    menuBounceAnim.delegate = self;
    menuBounceAnim.removedOnCompletion = NO;
    menuBounceAnim.fillMode = kCAFillModeForwards;
    menuBounceAnim.values = [self menuPositionValuesForMenuState:state];
    menuBounceAnim.timingFunctions = [self menuTimingFunctionsForMenuState:state];
    menuBounceAnim.keyTimes = [self menuKeyTimesForMenuState:state];
    
    [self.menuView.layer addAnimation:menuBounceAnim forKey:nil];
    [self.menuView.layer setValue:[menuBounceAnim.values lastObject] forKeyPath:@"position"];
}

- (void)addContentAnimationForMenuState:(LMDropdownViewState)state
{
    CAKeyframeAnimation *scaleBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleBounceAnim.duration = self.animationDuration;
    scaleBounceAnim.delegate = self;
    scaleBounceAnim.removedOnCompletion = NO;
    scaleBounceAnim.fillMode = kCAFillModeForwards;
    scaleBounceAnim.values = [self contentTransformValuesForMenuState:state];
    scaleBounceAnim.timingFunctions = [self contentTimingFunctionsForMenuState:state];
    scaleBounceAnim.keyTimes = [self contentKeyTimesForMenuState:state];
    
    [self.contentView.layer addAnimation:scaleBounceAnim forKey:nil];
    [self.contentView.layer setValue:[scaleBounceAnim.values lastObject] forKeyPath:@"transform"];
}


#pragma mark - PROPERTIES FOR KEYFRAME ANIMATION

- (NSArray *)menuPositionValuesForMenuState:(LMDropdownViewState)state
{
    CGFloat menuPositionX = self.menuView.layer.position.x;
    CGFloat menuPositionY = self.menuView.layer.position.y;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCGPoint:self.menuView.layer.position]];
    
    if (state == LMDropdownViewStateWillOpen || state == LMDropdownViewStateDidOpen)
    {
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(menuPositionX, desMenuCenter.y + 20)]];
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(menuPositionX, desMenuCenter.y)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(menuPositionX, menuPositionY + 20)]];
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(menuPositionX, originMenuCenter.y)]];
    }
    
    return values;
}

- (NSArray *)menuKeyTimesForMenuState:(LMDropdownViewState)state
{
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    return keyTimes;
}

- (NSArray *)menuTimingFunctionsForMenuState:(LMDropdownViewState)state
{
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

- (NSArray *)contentTransformValuesForMenuState:(LMDropdownViewState)state
{
    CATransform3D contentTransform = self.contentView.layer.transform;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCATransform3D:contentTransform]];
    
    if (state == LMDropdownViewStateWillOpen || state == LMDropdownViewStateDidOpen)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, self.closedScale-0.05, self.closedScale-0.05, self.closedScale-0.05)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, self.closedScale, self.closedScale, self.closedScale)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, 0.95, 0.95, 0.95)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
    
    return values;
}

- (NSArray *)contentKeyTimesForMenuState:(LMDropdownViewState)state
{
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    return keyTimes;
}

- (NSArray *)contentTimingFunctionsForMenuState:(LMDropdownViewState)state
{
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

@end
