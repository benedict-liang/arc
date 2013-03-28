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
    _leftBar = [[LeftBarViewController alloc] initWithFolder:_rootFolder delegate:self];
    
    
    CGRect window = [[UIScreen mainScreen] bounds];
    
    // ToolBar. Active only in portrait mode for now.
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, window.size.width, SIZE_TOOLBAR_HEIGHT)];
    
    //Toolbar Button
    UIBarButtonItem *overlayButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonSystemItemAction target:self action:@selector(triggerPopover:)];
    [_toolbar setItems:@[overlayButton]];
    [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    //Popover
    _popover = [[UIPopoverController alloc] initWithContentViewController:_leftBar];
    _popover.popoverContentSize = SIZE_POPOVER;
    
    // Add Subviews to Main View
    [self.view addSubview:_leftBar.view];
    
    [self.view addSubview:_codeView.view];
    
    // Resize Subviews
    [self resizeSubViews];
    
    TMBundleSyntaxParser *syntaxParser = [[TMBundleSyntaxParser alloc] init];
    NSArray *fileTypesArray = [syntaxParser getFileTypes:@"html.tmbundle"];
    
    NSLog(@"file types array: %@", fileTypesArray);
}

// Resizes SubViews Based on Application's Orientation
- (void)resizeSubViews
{
    CGRect window = [[UIScreen mainScreen] bounds];
    
    // TODO.
    // Omer (26.03.2013): Simply add toolbar when in Portrait and remove it when in Landscape.
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

// Shows/hides LeftBar
- (void)showLeftBar
{
    // TODO
}
- (void)hideLeftBar
{
    // TODO
}

// Shows the file using the CodeViewController
- (void)fileSelected:(File*)file
{
    [_codeView showFile:file];
}

// Updates Current Folder being Viewed
- (void)folderSelected:(Folder*)folder
{
    // TODO
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// enable autorotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self resizeSubViews];
    return YES;
}

// popover click callback
-(void)triggerPopover:(UIBarButtonItem*)button {
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
