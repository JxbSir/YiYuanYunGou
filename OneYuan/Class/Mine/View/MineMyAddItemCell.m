//
//  MineMyAddItemCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyAddItemCell.h"

@interface MineMyAddItemCell ()
{
    __weak id<MineMyAddItemCellDelegate> delegate;
    
    int     addressId;
    
    UILabel *lblName;
    UILabel *lblAddress;
    
    UILabel *lblDefault;
}
@end

@implementation MineMyAddItemCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        lblDefault = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 100, 10, 100, 15)];
        lblDefault.textColor = [UIColor redColor];
        lblDefault.text = @"默认地址";
        lblDefault.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblDefault];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, mainWidth - 40, 15)];
        lblName.textColor = [UIColor grayColor];
        lblName.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblName];
        
        
        lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, mainWidth - 40, 15)];
        lblAddress.textColor = [UIColor grayColor];
        lblAddress.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblAddress];
        
    }
    return self;
}

- (void)setAddress:(MineMyAddressItem *)item bShow:(BOOL)bShow
{
    lblDefault.hidden = !bShow;
    
    addressId = [item.ID intValue];
    
    lblName.text = [NSString stringWithFormat:@"%@   %@",item.Name,item.Mobile];
    
    lblAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",item.AName,item.BName,item.CName,item.DName,item.Address];
    
    if(![item.Default boolValue])
    {
        lblDefault.text = @"设为默认地址";
        lblDefault.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblDefault.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDefault)];
        [lblDefault addGestureRecognizer:tap];
    }
}

- (void)tapDefault
{
    if(delegate)
    {
        [delegate setDefault:addressId];
    }
}
@end
