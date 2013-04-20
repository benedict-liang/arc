//
//  ArcSplitViewController.m
//  arc
//
//  Created by Yong Michael on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ArcSplitViewController.h"

@interface ArcSplitViewController ()
@property UIView *masterView;
@property UIView *detailView;
@end

@implementation ArcSplitViewController
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Work Around
    // (force recalculation of self.view.bounds)
    // iOS initial frame is unreliable.
    [[UIApplication sharedApplication]
     setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    _masterView = _masterViewController.view;
    _detailView = _detailViewController.view;
    [self.view addSubview:_masterView];
    [self.view addSubview:_detailView];
    
    [self autoLayout:
     [[UIApplication sharedApplication]statusBarOrientation]];
}

- (void)autoLayout:(UIInterfaceOrientation)toInterfaceOrientation
{
    _masterView.frame =
    CGRectMake(0, 0, 320, self.view.bounds.size.height);
    
    _detailView.frame =
    CGRectMake(320, 0,
               self.view.bounds.size.width - 320,
               self.view.bounds.size.height);
}

# pragma mark - Layout Methods

- (void)showMasterView
{
    
}

- (void)hideMasterView
{
    
}

# pragma mark - Orientation Methods

- (BOOL)shouldAutorotate
{
    // Allow any orientation
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self autoLayout:toInterfaceOrientation];
}

@end
