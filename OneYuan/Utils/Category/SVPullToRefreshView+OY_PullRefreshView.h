//
//  SVPullToRefreshView+OY_PullRefreshView.h
//  TZS
//
//  Created by Peter Jin (https://github.com/JxbSir) on  14-12-22.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface OYSVCustomView : UIImageView
{
    
}
@end

@interface OYSVActivityIndicatorView : UIActivityIndicatorView
{
    
}
@end

@interface OYSVLabel : UILabel
{
    
}
@end

@interface SVPullToRefreshView (OY_PullRefreshView)
{
}
@property (nonatomic, strong) OYSVCustomView *oyCustomView;
@property (nonatomic, strong) OYSVActivityIndicatorView *indicator;
@property (nonatomic, strong) OYSVLabel *lblInfo;
@property (nonatomic, assign) BOOL isLoading;

- (void)setOYStyle;
@end
