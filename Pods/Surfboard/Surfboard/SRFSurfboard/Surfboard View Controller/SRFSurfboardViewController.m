//
//  MBSurfboardViewController.m
//  Surfboard
//
//  Created by Moshe on 8/10/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "SRFSurfboardViewController.h"
#import "SRFSurfboardPanelCell.h"   //  the panel cell
#import "SRFSurfboardPanel.h"
#import "UIButton+IndexPath.h"

/**
 *  An identifier for surfboard cells.
 */

static NSString *kSurfboardPanelIdentifier = @"com.mosheberman.surfboard-panel";

/**
 *  An extension of the surfbord view controller.
 */

@interface SRFSurfboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

/**
 *  An array of configuration elements.
 */

@property (nonatomic, strong) NSArray *panels;

/**
 *  An index of the current view.
 */

@property (nonatomic, assign) NSInteger index;

/**
 *  A page control.
 */

@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  A flag to control index updates during rotation.
 */

@property (nonatomic, assign) BOOL isRotating;

@end

@implementation SRFSurfboardViewController

#pragma mark - Initializers

/** ---
 *  @name Initializers
 *  ---
 */

/**
 *  Instantiates a new surfboard with an array of panel objects.
 *
 *  @param configuration An array of panels.
 *  @return An SRFSurfboardViewController.
 */

- (instancetype)initWithPathToConfiguration:(NSString *)path
{
    
    NSArray *panels = [SRFSurfboardViewController panelsFromConfigurationAtPath:path];
    
    self = [self initWithPanels:panels];
    
    if (self)
    {
        
    }
    
    return self;
}

/**
 *  Instantiates a new surfboard with an array of panel objects.
 *
 *  @param panels An array of panels.
 *  @return An SRFSurfboardViewController.
 */

- (instancetype)initWithPanels:(NSArray *)panels
{
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    if (self)
    {
        _panels = panels;
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.defersCurrentPageDisplay = YES;
        _pageControl.numberOfPages = panels.count;
        _isRotating = NO;
        _tintColor = [UIColor whiteColor];
        _backgroundColor = [UIColor blueColor];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithPanels:nil];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - View Lifecycle

/** ---
 *  @name View Lifecycle
 *  ---
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  Apply the tint color to the cells.
     */
    
    self.tintColor = self.tintColor;
    
    /**
     *  Apply a background color.
     */
    
    self.collectionView.backgroundColor = self.backgroundColor;
    
    /**
     *  Configure the layout.
     */
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    /**
     *  Register a nib for the surfboard panel class.
     */
    
    UINib *nib = [UINib nibWithNibName:@"SRFSurfboardPanelCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kSurfboardPanelIdentifier];
    
    /**
     *  Wire up the delegate and data source.
     */
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    /**
     *  Enable paging.
     */
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    /**
     *  Debug borders Yay!
     */
    
//        self.collectionView.layer.borderColor = [UIColor redColor].CGColor;
//        self.collectionView.layer.borderWidth = 2.0f;
}

/**
 *  Add a page control
 */

- (void)viewDidAppear:(BOOL)animated
{
    [self _addPageControl];
    [self _hackBorderOnPageControlSubviews];
    [self _adjustPageControlVisibilityForPanelAtIndex:self.index];
}

#pragma mark - UICollectionViewDataSource

/** ---
 *  @name UICollectionViewDataSource
 *  ---
 */

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.panels.count;
    
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SRFSurfboardPanelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSurfboardPanelIdentifier forIndexPath:indexPath];
    
    if (indexPath.row >= 0 && indexPath.row < self.panels.count)
    {
        SRFSurfboardPanel *panel = self.panels[indexPath.row];
        cell.panel = panel;
        
        [self _prepareButtonsInCell:cell atIndexPath:indexPath];
        
        [self _adjustPageControlVisibilityForPanelAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Wire Up the Buttons

- (void)_prepareButtonsInCell:(SRFSurfboardPanelCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  We need to prepare the buttons in this cell.
     */
    
    SRFSurfboardPanelCell *panelCell = (SRFSurfboardPanelCell *)cell;
    
    /**
     *  Start with an index of zero.
     */
    
    NSInteger buttonIndex = 0;
    
    if ([panelCell isKindOfClass:[SRFSurfboardPanelCell class]])
    {
        for (UIView *view in panelCell.contentView.subviews)
        {
            
            /**
             *  For each button, set the tag, then increment.
             */
            
            if ([view isKindOfClass:[UIButton class]])
            {
                /**
                 *  Grab the button.
                 */
                
                UIButton *button = (UIButton *)view;
                
                if([button respondsToSelector:@selector(setIndexPath:)])
                {
                    /**
                     *  The indexPath is added in class extension defined in the UIButton_Surfboard.h header.
                     *  Here we set the indexPath based on the panel and the index.
                     */
                    
                    button.indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:indexPath.row];
                    
                    /**
                     *  Increment the buttonIndex.
                     */
                    
                    buttonIndex++;
                    
                    /**
                     *  Remove any old wiring from the button and wire it up again.
                     */
                    
                    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    NSLog(@"(SRFSurfboardViewController) : Failed to load UIButton extension. Buttons will not work.");
                }
            }
        }
        
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout

/** ---
 *  @name UICollectionViewDelegateFlowLayout
 *  ---
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - Setters

/** ---
 *  @name Setters
 *  ---
 */

/**
 *  Sets the panels and reloads the surfboard.
 *
 *  @param panels An array of panels.
 */

- (void)setPanels:(NSArray *)panels
{
    _panels = panels;
    
    [[self collectionViewLayout] invalidateLayout];
    [[self collectionView] reloadData];
}

/**
 *  Sets the tint color and reloads the collection view.
 *
 *  @param tintColor A tint color to apply to the surfboard.
 */

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    self.collectionView.tintColor = tintColor;
    [self.collectionView reloadData];
}

/**
 *
 */

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.collectionView.backgroundColor = backgroundColor;
}

#pragma mark - Load Panels from Configuration

/** ---
 *  @name Load Panels From Configuration
 *  ---
 */

/**
 *  Loads panels out from a given path.
 *
 *  @param path The path from which to load the panel configuration.
 *
 *  @return An array of panels.
 */

+ (NSArray *)panelsFromConfigurationAtPath:(NSString *)path
{
    NSData *panelData = [[NSData alloc] initWithContentsOfFile:path];
    
    NSMutableArray *panels = [[NSMutableArray alloc] init];
    
    if (panelData)
    {
        NSArray *panelDictionaries = [NSJSONSerialization JSONObjectWithData:panelData options:0 error:nil];
        
        /**
         *  Iterate the panel dictionaries and "inflate" them into objects.
         */
        
        for (NSDictionary *panelDictionary in panelDictionaries)
        {
            SRFSurfboardPanel *panel = [[SRFSurfboardPanel alloc] initWithConfiguration:panelDictionary];
            [panels addObject:panel];
        }
    }
    
    return panels;
}

#pragma mark - Rotation Handling

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    /**
     *  Enable the rotation flag.
     */
    self.isRotating = YES;
    
    //  Ensure we have the right index.
    [self.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /**
     *  Disable the rotation flag.
     */
    
    self.isRotating = NO;
    
    /**
     *  Force the layout to redraw, which will resize the cells.
     */
    
    [self.collectionViewLayout invalidateLayout];
    
    /**
     *  Center the previously centered cell.
     */
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    /**
     *  Update the page control.
     */
    [self _positionPageControl];
    [self _adjustPageControlVisibilityForPanelAtIndex:self.index];
}

#pragma mark - UIScrollViewDelegate

/**
 *  Although we adjust the page control's
 *  alpha when dequeuing a cell, we need to
 *  to so again after dragging, just in case
 *  there's a false start.
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _adjustPageControlVisibilityForPanelAtIndex:self.index];
    
    if ([self.delegate respondsToSelector:@selector(surfboard:didShowPanelAtIndex:)])
    {
        [self.delegate surfboard:self didShowPanelAtIndex:self.index];
    }
}

/**
 *  Whenever the collection view scrolls,
 *  we need to update the page control.
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isRotating == YES)
    {
        return;
    }
    
    self.index = [self _calculatedIndex];
    [self _positionPageControl];
    [self _selectActivePage];
    
    [self.collectionView sendSubviewToBack:self.pageControl];
}

#pragma mark - Page Control

/**
 *  This method sets the number of pages,
 *  resizes the page control, positions
 *  it, and finally, adds the page control
 *  to the view hierarchy.
 */

- (void)_addPageControl
{
    self.pageControl.numberOfPages = self.panels.count;
    
    [self.pageControl sizeToFit];
    
    self.pageControl.alpha = 0.0f;
    
    [self.collectionView addSubview:self.pageControl];
    [self.collectionView sendSubviewToBack:self.pageControl];
    
    [self _positionPageControl];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.pageControl.alpha = 1.0f;
    }];
}

/**
 *  This method calculates and sets the
 *  current page of the page control.
 */

- (void)_selectActivePage
{
    self.pageControl.currentPage = self.index;
}

/**
 *  This method calculate and sets
 *  the position of the page control.
 */

- (void)_positionPageControl
{
    
    if (![self.collectionView.subviews containsObject:self.pageControl])
    {
        
        NSLog(@"(SRFSurfboard) : I can't layout the page control until it's in the view hierarchy.");
        return;
    }
    
    CGRect visibleRect = [self _visibleRect];
    
    CGFloat pageControlX = CGRectGetMidX(visibleRect);
    CGFloat pageControlY = CGRectGetHeight(self.collectionView.bounds) - CGRectGetHeight(self.pageControl.frame);
    
    CGPoint center = CGPointMake(pageControlX, pageControlY);
    
    self.pageControl.center = center;
}

/**
 *  Hides the page control if we think
 *  that it will overlap a button.
 */

- (void)_adjustPageControlVisibilityForPanelAtIndex:(NSInteger)index
{
    
    /**
     *  Get a panel, if we have one at the current index.
     */
    
    SRFSurfboardPanel *panel = nil;
    
    if (index >= 0 || index < self.panels.count)
    {
        panel = self.panels[index];
    }
    
    /**
     *  If there are one or more button titles,
     *  we need to hide the page control, so
     *  it doesn't overlap the cell.
     *
     *  Also, if we didn't get a panel in the
     *  previous step, we're going to simply
     *  hide the page control.
     */
    
    if (panel.buttonTitle || panel == nil)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.pageControl.alpha = 0.0f;
        }];
    }
    
    /**
     *  Otherwise, we want to ensure that the
     *  page control is visible.
     */
    
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.pageControl.alpha = 1.0f;
        }];
    }
    
    /**
     *  Add a border to each dot in the page control.
     */
    
    [self _hackBorderOnPageControlSubviews];
}

- (void)_hackBorderOnPageControlSubviews
{
    for (UIView *view in self.pageControl.subviews)
    {
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1.0f;
    }
}
#pragma mark - Scrolling Progress

/** ---
 *  @name Scrolling Progress
 *  ---
 */

/**
 *  Calculates the index based on the offset and the visible rect.
 */

- (NSInteger)_calculatedIndex
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat offset = self.collectionView.contentOffset.x;
    CGFloat index = offset/width;
    return index;
}

/**
 *  Calculates the visible rectangle of the collection view.
 */

- (CGRect)_visibleRect
{
    CGRect visibleRect =  CGRectZero;
    visibleRect.size = self.collectionView.bounds.size;
    visibleRect.origin = self.collectionView.contentOffset;
    
    return visibleRect;
}

#pragma mark - Button Delegate

/** ---
 *  @name Button Delegate
 *  ---
 */

/**
 *  Called when a button is tapped.
 */

- (void)buttonTapped:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(surfboard:didTapButtonAtIndexPath:)])
    {
        [self.delegate surfboard:self didTapButtonAtIndexPath:button.indexPath];
    }
}

@end
