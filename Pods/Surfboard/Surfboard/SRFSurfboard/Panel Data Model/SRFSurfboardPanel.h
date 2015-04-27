//
//  SRFSurfboardPanel.h
//  Surfboard
//
//  Created by Moshe on 8/12/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A panel type enum - for future use.
 */

NS_ENUM(NSInteger, SRFSurfboardPanelType)
{
    SRFSurfboardPanelDefault = 0    // A panel with a block of text at the top, an image, and an optional button.
};

@interface SRFSurfboardPanel : NSObject

/**
 *  The text to display in the panel.
 */

@property (nonatomic, strong) NSString *text;

/**
 *  An image to load into the panel.
 *
 *  For the default panel, the dimensions of this 
 *  image should be 140 points wide and 250 points
 *  tall, or a multiple of that ratio.
 */

@property (nonatomic, strong) UIImage *image;

/**
 *  A title for a button.
 *
 *  If this is set to nil, the panel cell will 
 *  hide its button.
 */

@property (nonatomic, strong) NSString *buttonTitle;

/**
 *  Creates a panel with the configuration.
 *
 *  @param configuration A dictionary with configuration options.
 *  @return A pane.
 */

- (instancetype)initWithConfiguration:(NSDictionary *)configuration;

@end
