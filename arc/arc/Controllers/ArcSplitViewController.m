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
@synthesize delegate = _delegate;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;
@synthesize masterViewVisible = _masterViewVisible;

- (id)init
{
    self = [super init];
    if (self) {
        _masterViewVisible = YES;
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
}

- (void)autoLayout:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (_masterViewVisible) {
        [self showMasterViewAnimated:NO];
    } else {
        [self hideMasterViewAnimated:NO];
    }
}

# pragma mark - Layout Methods

- (void)showMasterViewAnimated:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self showMasterView];
                         }
                         completion:^(BOOL finished){
                             _masterViewVisible = YES;
                             [self.delegate resizeSubViews];
                         }];
    } else {
        [self showMasterView];
        _masterViewVisible = YES;
    }
}

- (void)showMasterView
{
    _masterView.frame =
    CGRectMake(0, 0, 320, self.view.bounds.size.height);
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) {
        _detailView.frame =
        CGRectMake(320, 0,
                   self.view.bounds.size.width - 320,
                   self.view.bounds.size.height);
    } else {
        _detailView.frame =
        CGRectMake(320, 0,
                   self.view.bounds.size.width,
                   self.view.bounds.size.height);
    }
}

- (void)hideMasterViewAnimated:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self hideMasterView];
                         }
                         completion:^(BOOL finished){
                             _masterViewVisible = NO;
                             [self.delegate resizeSubViews];
                         }];
    } else {
        [self hideMasterView];
        _masterViewVisible = NO;
    }
}

- (void)hideMasterView
{
    _masterView.frame =
    CGRectMake(-320, 0, 320, self.view.bounds.size.height);
    
    _detailView.frame =
    CGRectMake(0, 0,
               self.view.bounds.size.width,
               self.view.bounds.size.height);
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
