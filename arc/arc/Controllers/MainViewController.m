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
@property UIToolbar *toolbar;
@property UIPopoverController *popover;
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
    
    // ToolBar. Active only in portrait mode for now.
    CGRect window = [[UIScreen mainScreen] bounds];
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, window.size.width, SIZE_TOOLBAR_HEIGHT)];
    
    UIBarButtonItem *overlayButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonSystemItemAction target:self action:@selector(triggerPopover:)];
    [_toolbar setItems:@[overlayButton]];
    [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    _popover = [[UIPopoverController alloc] initWithContentViewController:_leftBar];
    _popover.popoverContentSize = SIZE_POPOVER;
    
    // Add Subviews to Main View
    [self.view addSubview:_codeView.view];
    
    [self.view addSubview:_leftBar.view];
    
    // Resize Subviews
    [self resizeSubViews];
}

// Resizes SubViews Based on Application's Orientation
- (void)resizeSubViews
{
    CGRect window = [[UIScreen mainScreen] bounds];
    // TODO.
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        _codeView.view.frame = window;
        [self.view addSubview:_toolbar];
        
    } else {
        _codeView.view.frame = CGRectMake(SIZE_LEFTBAR_WIDTH, 0, window.size.width, window.size.height);
        _leftBar.view.frame = CGRectMake(0, 0, SIZE_LEFTBAR_WIDTH, window.size.height);
        [_toolbar removeFromSuperview];
        [_popover dismissPopoverAnimated:NO];
        [self.view addSubview:_leftBar.view];
        
    }
    
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self resizeSubViews];
    return YES;
}
-(void)triggerPopover:(UIBarButtonItem*)button {
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
