//
//  LeftBarViewController.m
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize delegate = _delegate;
@synthesize fileNavigationViewController = _fileNavigationViewController;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor blueColor];
        self.view.autoresizesSubviews = YES;
    }
    return self;
}

- (void)setDelegate:(id<MainViewControllerDelegate>)delegate
{
    _delegate = delegate;
    _fileNavigationViewController.delegate = delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // File Navigator View Controller
    _fileNavigationViewController = [[FileNavigationViewController alloc] init];
    [self addChildViewController:_fileNavigationViewController];
    
    _fileNavigationViewController.view.frame = self.view.bounds;
    [self.view addSubview:_fileNavigationViewController.view];
}

@end
