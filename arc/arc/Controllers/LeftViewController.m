//
//  LeftBarViewController.m
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LeftViewController.h"
#import "FileNavigationViewController.h"
#import "SettingsViewController.h"

@interface LeftViewController ()
@property FileNavigationViewController* fileNavigationViewController;
@property SettingsViewController *settingsViewController;
@end

@implementation LeftViewController
@synthesize delegate = _delegate;
@synthesize settingsViewController = _settingsViewController;
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
    
    // Assign Delegate to ChildViewControllers
    for (id<SubViewController> childVC in self.childViewControllers) {
        childVC.delegate = delegate;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // File Navigator View Controller
    _fileNavigationViewController = [[FileNavigationViewController alloc] init];
    [self addChildViewController:_fileNavigationViewController];
    
    _settingsViewController = [[SettingsViewController alloc] init];
    [self addChildViewController:_settingsViewController];
    
    // TMP.
//    _fileNavigationViewController.view.frame = self.view.bounds;
//    [self.view addSubview:_fileNavigationViewController.view];

    _settingsViewController.view.frame = self.view.bounds;
    [self.view addSubview:_settingsViewController.view];
    
}

@end
