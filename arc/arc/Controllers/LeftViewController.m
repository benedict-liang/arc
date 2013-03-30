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
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor blueColor];
        self.view.autoresizesSubviews = YES;
    }
    return self;
}

- (void)setupFileNavWithFolder:(Folder*)folder
{
//    _navController = [[UINavigationController alloc] initWithRootViewController:_fileNav];
//    [self.view addSubview:_navController.view];
//    [self.view addSubview:_fileNav.view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // File Navigator View Controller
    _fileNav = [[FileNavigationViewController alloc] init];
    _fileNav.delegate = self.delegate;
    _fileNav.view.frame = self.view.bounds;
    [self.view addSubview:_fileNav.view];
}

@end
