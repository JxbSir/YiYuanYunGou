//
//  BaseLoadView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "BaseLoadView.h"

@interface BaseLoadView ()
{
    UIActivityIndicatorView *loadView;
}

@end

@implementation BaseLoadView

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if(loadView)
    {
        [loadView stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
  
        
        loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadView.frame = CGRectMake((frame.size.width - 32) / 2, frame.size.height / 2 - 100, 32, 32);
        [loadView startAnimating];
        [self addSubview:loadView];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 100) / 2, loadView.frame.origin.y + 40, 100, 100)];
        img.image = [UIImage imageNamed:@"mainBg"];
        [self addSubview:img];
    }
    return self;
}

@end
