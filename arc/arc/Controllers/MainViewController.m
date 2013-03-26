//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "MainViewController.h"

@interface MainViewController ()
@property CodeViewController *codeView;
@property LeftBarViewController *leftBar;
@property RootFolder *rootFolder;
@end

@implementation MainViewController
@synthesize codeView = _codeView;
@synthesize leftBar = _leftBar;
@synthesize rootFolder = _rootFolder;

- (void)loadView
{
    [self setView:
     [[UIView alloc]
      initWithFrame:[[UIScreen mainScreen] bounds]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _rootFolder = [RootFolder getInstance];
    
    // CodeView
    _codeView = [[CodeViewController alloc] init];
    _codeView.delegate = self;

    // LeftBar
    _leftBar = [[LeftBarViewController alloc] initWithFolder:_rootFolder];
    _leftBar.delegate = self;
    
    // Add Subviews to Main View
    [self.view addSubview:_leftBar.view];
    [self.view addSubview:_codeView.view];
    
    // Resize Subviews
    [self resizeSubViews];
}

// Resizes SubViews Based on Application's Orientation
- (void)resizeSubViews
{
    // TODO.
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        
    } else {
        
    }

    _codeView.view.frame = self.view.frame;
    _leftBar.view.frame = CGRectMake(0, 0, SIZE_LEFTBAR_WIDTH, self.view.bounds.size.height);
}


#pragma mark - MainViewControllerDelegate Methods

// Shows the file using the CodeViewController
- (void)showFile:(File*)file {

}

// Updates the FileNavigatorViewController view after adding a folder
- (void)updateAddFolderView:(Folder*)folder {
    
}

// Updates the FileNavigatorViewController view after adding a file
- (void)updateAddFileView:(File*)file {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
