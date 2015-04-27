//
//  SRFSurfboardDelegate.h
//  Surfboard
//
//  Created by Moshe on 8/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRFSurfboardViewController;
@class SRFSurfboardPanel;

@protocol SRFSurfboardDelegate <NSObject>

@optional

/**
 *  Called when the user taps a button in a panel.
 *
 *  @param surfboard The surfboard containing the button.
 *  @param indexPath The index path of the button. 
 *
 *
 *  @discussion The section is the panel index, the 
 *  row is the button index within the panel.
 *
 *  Both the button and panel index are zero based.
 *
 *  Tapping on the second button in the first panel 
 *  would produce an indexPath where the section is 0
 *  and the row is 1.
 *
 *  You can use indexPath.section to get the panel 
 *  where the touch originated from.
 *
 */

- (void)surfboard:(SRFSurfboardViewController*)surfboard didTapButtonAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Called when the surfboard changes to a panel.
 *
 *  @param index The index of the panel.
 */

- (void)surfboard:(SRFSurfboardViewController *)surfboard didShowPanelAtIndex:(NSInteger)index;


@end
