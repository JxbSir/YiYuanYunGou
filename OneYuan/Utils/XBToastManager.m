//
//  XBToastManager.m
//  XB
//
//

#import "AppDelegate.h"
#import "XBToastManager.h"

#define minshowtime   0.5
#define progesswidth  5.
#define rotationspeed 2
#define customcenter  CGPointMake(22.5, 22.5)

@interface XBAnnurImageView :UIImageView {
@public
    UIBezierPath *trackPath;
    CAShapeLayer *trackLayer;
    UIBezierPath *progressPath;
    CAShapeLayer *progressLayer;
}
@end

@implementation XBAnnurImageView

#pragma mark -initWithFrame
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self actionRenderLayerComponents];
    }
    return self;
}

#pragma mark -actionRenderLayerComponents
- (void)actionRenderLayerComponents {
    
    trackLayer = [CAShapeLayer layer];
    trackPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                               radius:(CGRectGetWidth(self.bounds)-progesswidth)/2. startAngle:0
                                             endAngle:M_PI*2 clockwise:YES];
    trackLayer.frame = self.bounds;
    trackLayer.path = trackPath.CGPath;
    trackLayer.lineWidth = progesswidth;
    trackLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:trackLayer];
    
    progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(22.5, 22.5) radius:(CGRectGetWidth(self.bounds)-progesswidth)/2. startAngle:-M_PI_2 endAngle:M_PI/3 clockwise:YES];
    progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bounds;
    progressLayer.lineWidth = progesswidth;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.path = progressPath.CGPath;
    progressLayer.strokeColor = RGB(100, 100, 87).CGColor;
    [self.layer addSublayer:progressLayer];
}

#pragma mark -actionRotationAnimation
- (void)actionRotationAnimation:(CGFloat)speed {
    [progressLayer removeAllAnimations];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2];
    rotationAnimation.duration = speed;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [progressLayer addAnimation:rotationAnimation forKey:@"rotationAnimation1"];
}
@end


@interface XBToastManager () {
    NSTimer *progresstimer;
    MBProgressHUD *toastHud;
    MBProgressHUD *progressHud;
    XBAnnurImageView *annurImageView;
}
@end

static XBToastManager *toastManager;
@implementation XBToastManager

#pragma mark -manager
+ (XBToastManager *)ShardInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toastManager = [[XBToastManager alloc] init];
        [toastManager actionRenderUIComponents];
    });
    return toastManager;
}

#pragma mark -keyWindow
+ (UIWindow *)keyWindow {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *keywindow = delegate.window;
    return keywindow;
}

#pragma mark -actionRenderUIComponents
- (void)actionRenderUIComponents {
    UIWindow *keywindow = [XBToastManager keyWindow];
    toastHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    toastHud.minSize = CGSizeMake(220, 60);
    toastHud.userInteractionEnabled = NO;
    toastHud.mode = MBProgressHUDModeText;
    toastHud.minShowTime = minshowtime*2;
    toastHud.color = [UIColor hexFloatColor:@"545454"];
    toastHud.alpha = 0.3;
    [keywindow addSubview:toastHud];
    progressHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    progressHud.animationType = MBProgressHUDAnimationFade;
    //progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.userInteractionEnabled = YES;
    progressHud.minShowTime = minshowtime;
    progressHud.labelText = @"加载中...";
    progressHud.square = YES;
    //annurImageView = [[XiangQuAnnurImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    //progressHud.customView = annurImageView;
    [keywindow addSubview:progressHud];
}

#pragma mark -toast
- (void)showtoast:(NSString *)toastStr {
    if (toastStr.length > 0) {
        if (toastStr.length > 15) {
            toastHud.labelText = @"";
            toastHud.detailsLabelText = toastStr;
        } else {
            toastHud.labelText = toastStr;
            toastHud.detailsLabelText = @"";
        }
        [[XBToastManager keyWindow] bringSubviewToFront:toastHud];
        [toastHud show:YES];
        [toastHud hide:YES];
    }
}

- (void)showtoast:(NSString *)toastStr wait:(double)wait
{
    toastHud.minShowTime = wait;
    [self showtoast:toastStr];
    toastHud.minShowTime = minshowtime * 2;
}

#pragma mark -progress
- (void)hideprogress {
    [progressHud hide:YES];
    [toastHud hide:YES];
}

- (void)showprogress {
    [toastHud hide:YES];
    [[XBToastManager keyWindow] bringSubviewToFront:progressHud];
    [progressHud setMinShowTime:0];
    progressHud.labelText  = @"";
    [toastManager actionCountProgress];
    [progressHud show:NO];
}

- (void)showHUD:(HUDShowType)type
{
    if (type <= HUDShowType_None)
        return;
    [self showprogress];
}

#pragma mark -actionRemoveAnimation
- (void)actionRemoveAnimation {
    [annurImageView->progressLayer removeAllAnimations];
}

#pragma mark -actionCountProgress
- (void)actionCountProgress {
    [annurImageView actionRotationAnimation:rotationspeed];
}

@end
