//
//  IPDashedLineView.h
//  IPDashedLine
//
//  Created by Colin Brash on 5/30/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IPDashedLineViewDirection) {
    IPDashedLineViewDirectionAutomatic = 0,
    IPDashedLineViewDirectionHorizontalFromLeft,
    IPDashedLineViewDirectionHorizontalFromRight,
    IPDashedLineViewDirectionVerticalFromTop,
    IPDashedLineViewDirectionVerticalFromBottom,
};


/**
 UIView with a customizable dashed look, generally used for dashed lines.
 */
@interface IPDashedLineView : UIView <UIAppearanceContainer>

/**
 Forced direction of the line if this is not Automatic.
 Default is BBDashedLineViewDirectionAutomatic.  This will auto select
 HorizontalFromLeft or VerticalFromTop depending on width vs height ratio.
 */
@property (assign, nonatomic) IPDashedLineViewDirection direction UI_APPEARANCE_SELECTOR;

/**
 How many pts into the drawing we start.
 Default is 0.
 */
@property (assign, nonatomic) CGFloat phase UI_APPEARANCE_SELECTOR;

/**
 Passing an array with the values [2,3] sets a dash pattern that alternates between a
 2 pt lineColor painted segment and a 3 pt backgroundColor unpainted
 segment. Passing the values [1,3,4,2] sets the pattern to a 1-unit painted segment,
 a 3-unit unpainted segment, a 4-unit painted segment, and a 2-unit unpainted segment.
 Default is @[@2, @2].
 */
@property (strong, nonatomic) NSArray *lengthPattern UI_APPEARANCE_SELECTOR;

/**
 Color of the dashes. Use backgroundColor for the non-dash color.
 Default is black.
 */
@property (strong, nonatomic) UIColor *lineColor UI_APPEARANCE_SELECTOR;

@end
