//
//  JxbAdPageView.m
//  JxbAdPageView
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/11.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "JxbAdPageView.h"

#define mainWidth           [[UIScreen mainScreen] bounds].size.width
#define defaultInterval     5
#define addBeyond           2

@interface JxbAdPageView()<UIScrollViewDelegate>
{
    __weak  id<JxbAdPageViewDelegate> delegate;
    NSTimer       *autoTimer;
    UIPageControl *pcView;
    UIScrollView  *scView;
    int           adCount;
}
@property (nonatomic,assign)NSTimeInterval autoInterval;
@end

@implementation JxbAdPageView
@synthesize delegate;

- (void)dealloc
{
    if (autoTimer)
    {
        [autoTimer invalidate];
        autoTimer = nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setAds:(NSArray*)imgNameArr
{
    adCount = (int)imgNameArr.count;
    if(autoTimer)
        [autoTimer invalidate];
    {
        scView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scView.backgroundColor = [UIColor whiteColor];
        scView.pagingEnabled = YES;
        scView.showsHorizontalScrollIndicator = NO;
        scView.showsVerticalScrollIndicator = NO;
        scView.delegate = self;
        [self addSubview:scView];
    }
    
    for (UIView* v in scView.subviews) {
        [v removeFromSuperview];
    }
    NSMutableArray* tmp = [NSMutableArray array];
    scView.contentSize = CGSizeMake((imgNameArr.count + ((adCount>1)?addBeyond*2:0)) * mainWidth, self.bounds.size.height);
    for (int i = 0; i < imgNameArr.count+ ((adCount>1)?addBeyond*2:0); i++)
    {
        NSString* name = nil;
        if (adCount == 1)
        {
            name = [imgNameArr objectAtIndex:i];
        }
        else
        {
            if(i<addBeyond)
            {
                name = [imgNameArr objectAtIndex:imgNameArr.count+i-addBeyond];
            }
            else if(i>=imgNameArr.count+addBeyond)
            {
                name = [imgNameArr objectAtIndex:i-imgNameArr.count-addBeyond];
            }
            else name = [imgNameArr objectAtIndex:i-addBeyond];
        }
        [tmp addObject:name];
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(i * mainWidth, 0, mainWidth, self.bounds.size.height)];
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
        [img addGestureRecognizer:tap];
        [img setImage_oy:nil image:name];
        [scView addSubview:img];
    }
    scView.contentOffset = CGPointMake(((adCount>1)?mainWidth*addBeyond:0), 0);
    
    if(!pcView)
    {
        pcView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, mainWidth, 30)];
        pcView.userInteractionEnabled = NO;
        pcView.currentPage = 0;
        pcView.pageIndicatorTintColor = [UIColor grayColor];
        pcView.currentPageIndicatorTintColor = [UIColor redColor];
    }
    [self addSubview:pcView];
    
    pcView.numberOfPages = imgNameArr.count;
    
    if (_autoInterval == 0)
        _autoInterval = defaultInterval;
    if (autoTimer)
    {
        [autoTimer invalidate];
        autoTimer = nil;
    }
    if(adCount > 1)
    {
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:_autoInterval target:self selector:@selector(handleScrollTimer) userInfo:nil repeats:YES];
        //[[NSRunLoop currentRunLoop] addTimer:autoTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - auto scroll timer
- (void)handleScrollTimer
{
    CGFloat x = scView.contentOffset.x;
    int page = x / mainWidth;
    if ((x - page * mainWidth) > mainWidth / 2)
        page++;
    int next = page+1;
    [scView scrollRectToVisible:CGRectMake(next * mainWidth, 0, mainWidth, self.bounds.size.height) animated:YES];
    [self setAdViews:next bFromTimer:YES];
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    int page = x / mainWidth;
    if ((x - page * mainWidth) > mainWidth / 2)
        page++;

    [self setAdViews:page bFromTimer:NO];
}

- (void)setAdViews:(int)page bFromTimer:(BOOL)bFromTimer
{
    if(page>=adCount+addBeyond)
    {
        if(!bFromTimer)
            scView.contentOffset = CGPointMake(mainWidth*addBeyond, 0);
        else
            [self performSelector:@selector(setConttentOffset:) withObject:[NSNumber numberWithFloat:mainWidth*addBeyond] afterDelay:0.5];
        page = 0;
    }
    else if(page < addBeyond)
    {
        scView.contentOffset = CGPointMake(mainWidth*(adCount+addBeyond-1), 0);
        page = adCount+addBeyond;
    }
    pcView.currentPage = page - addBeyond;
    [pcView updateCurrentPageDisplay];
    
    if (autoTimer)
    {
        [autoTimer invalidate];
        autoTimer = nil;
    }
    if(adCount > 1)
    {
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:_autoInterval target:self selector:@selector(handleScrollTimer) userInfo:nil repeats:YES];
    }
}

- (void)setConttentOffset:(NSNumber*)x
{
    scView.contentOffset = CGPointMake([x floatValue], 0);
}

- (void)Actiondo
{
    if(delegate)
    {
        [delegate click:(int)pcView.currentPage];
    }
}
@end
