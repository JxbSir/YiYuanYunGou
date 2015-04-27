//
//  HomeNewLoadView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeNewLoadView.h"

@interface HomeNewLoadView ()
{
    UIImageView             *imgProduct;
    UIActivityIndicatorView *imgLoad;
}
@end

@implementation HomeNewLoadView

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if(imgLoad)
    {
        [imgLoad stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imgLoad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imgLoad startAnimating];
        imgLoad.frame = CGRectMake((frame.size.width - 50) / 2, (frame.size.height - 32) / 2, 32, 32);
        [self addSubview:imgLoad];
        
        imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 50, 10, 40, frame.size.height - 20)];
        imgProduct.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgProduct];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    return self;
}


@end
