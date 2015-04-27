//
//  OYDownLibVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/4/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "OYDownLibVC.h"

@interface OYDownLibVC ()
@property(nonatomic,strong)__block ASProgressPopUpView  *popProgress;
@end

@implementation OYDownLibVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.8;
    _popProgress = [[ASProgressPopUpView alloc] init];
    _popProgress.popUpViewCornerRadius = 12.0;
    _popProgress.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28];
    _popProgress.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    _popProgress.frame = CGRectMake(30, mainHeight / 2 - 50, mainWidth - 60, 2);
    _popProgress.progress = 0;
    [_popProgress showPopUpViewAnimated:YES];
    [self.view addSubview:_popProgress];
    
    UILabel* lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, mainHeight / 2, mainWidth, 20)];
    lblInfo.text = @"正在更新数据库，请耐心等待...";
    lblInfo.textColor = mainColor;
    lblInfo.font = [UIFont systemFontOfSize:18];
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblInfo];
    
    
    __weak typeof (self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [wSelf download];
    });
    
}

- (void)download
{
    NSLog(@"%@",NSHomeDirectory());
    NSString* libFile = [NSString stringWithFormat:@"%@/Documents/down",NSHomeDirectory()];
    BOOL isDir = NO;
    if([[NSFileManager defaultManager]fileExistsAtPath:libFile isDirectory:&isDir])
        [[NSFileManager defaultManager] removeItemAtPath:libFile error:nil];
    
    __weak typeof (self) wSelf = self;
    TCBlobDownloader* down = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:_downloadUrl] downloadPath:libFile firstResponse:nil progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress){
        CGFloat p =  1.0 * receivedLength / totalLength;
        NSLog(@"%.2f",p);
        _popProgress.progress = p;
        [_popProgress showPopUpViewAnimated:YES];
        
    } error:^(NSError* error){
        NSLog(@"%@",error);
    } complete:^(BOOL downloadFinished, NSString *pathToFile){
        NSLog(@"%@",pathToFile);
        ZipArchive* zip = [[ZipArchive alloc] init];
        if( [zip UnzipOpenFile:pathToFile] )
        {
            BOOL ret = [zip UnzipFileTo:libFile overWrite:YES];
            if( ret )
            {
                [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/OY.framework"] error:nil];
                [[NSFileManager defaultManager]copyItemAtPath:[libFile stringByAppendingPathComponent:@"/OY.framework"] toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/OY.framework"] error:nil];
            }
            [zip UnzipCloseFile];
            [[NSFileManager defaultManager] removeItemAtPath:libFile error:nil];
        }
        [[NSFileManager defaultManager] removeItemAtPath:pathToFile error:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:_libVersion forKey:kSaveLibVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [wSelf.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidShowCart object:nil];
    }];
    [down start];
}


@end
