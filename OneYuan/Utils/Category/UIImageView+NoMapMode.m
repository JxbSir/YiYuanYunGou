//
//  UIImageView+NoMapMode.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "UIImageView+NoMapMode.h"

@implementation UIImageView (NoMapMode)

- (void)setImage_oy:(NSString*)baseUrl image:(NSString *)image
{
    BOOL on = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoMapMode] boolValue];
    if(on && ![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi])    {
        [self setImage:[UIImage imageNamed:@"noimage"]];
    }
    else
    {
        NSString* url = nil;
        if(baseUrl)
            url = [baseUrl stringByAppendingString:image];
        else
            url = image;
        [self sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}
@end
