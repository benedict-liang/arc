//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "MainViewController.h"

@interface MainViewController ()
@property CodeViewController *codeViewController;
@property LeftBarViewController *leftBarViewController;
@property RootFolder *rootFolder;
@property UIToolbar *toolbar;
@property UIPopoverController *popover;
@end

@implementation MainViewController
@synthesize codeViewController = _codeViewController;
@synthesize leftBarViewController = _leftBarViewController;
@synthesize rootFolder = _rootFolder;

- (id)init
{
    self = [super init];
    if (self) {
        // tmp. should use application state
        _rootFolder = [RootFolder sharedRootFolder];
        
//        // CodeView
//        _codeViewController = [[CodeViewController alloc] init];
//        _codeViewController.delegate = self;
//        
//        // LeftBar
//        _leftBarViewController = [[LeftBarViewController alloc] init];
//        _leftBarViewController.delegate = self;
//        
//        // MainViewController is a SplitViewController
//        self.viewControllers = [NSArray arrayWithObjects:
//                                _leftBarViewController,
//                                _codeViewController,
//                                nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    // ToolBar. Active only in portrait mode for now.
//    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, window.size.width, SIZE_TOOLBAR_HEIGHT)];
//    
//    //Toolbar Button
//    UIBarButtonItem *overlayButton = [[UIBarButtonItem alloc] initWithTitle:@"Open"
//                                                                      style:UIBarButtonSystemItemAction
//                                                                     target:self
//                                                                     action:@selector(triggerPopover:)];
//    [_toolbar setItems:@[overlayButton]];
//    [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
//    
//    //Popover
//    _popover = [[UIPopoverController alloc] initWithContentViewController:_leftBar];
//    _popover.popoverContentSize = SIZE_POPOVER;
    
    // Resize Subviews
//    [self resizeSubViews];
    
//    NSArray *sectionHeaders = [TMBundleSyntaxParser getKeyList:@"javascript.tmbundle"];
//    NSArray *patternsArray = [TMBundleSyntaxParser getPlistData:@"javascript.tmbundle"
//                                               withSectionHeader:[sectionHeaders objectAtIndex:0]];
//    
//    //NSLog(@"section headers array: %@", sectionHeaders);
//    //NSLog(@"patterns array: %@", patternsArray);
//    NSDictionary *temp = [TMBundleThemeHandler produceStylesWithTheme:nil];
//    // tmp
//    [_codeViewController showFile:[ApplicationState getSampleFile]];
}

// Resizes SubViews Based on Application's Orientation
- (void)resizeSubViews
{
    CGRect window = [[UIScreen mainScreen] bounds];
    
    // TODO.
    // Omer (26.03.2013): Simply add toolbar when in Portrait and remove it when in Landscape.
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        _codeViewController.view.frame = window;
        [self.view addSubview:_toolbar];
        
    } else {
        _codeViewController.view.frame = CGRectMake(SIZE_LEFTBAR_WIDTH, 0, window.size.width, window.size.height);
        _leftBarViewController.view.frame = CGRectMake(0, 0, SIZE_LEFTBAR_WIDTH, window.size.height);
        [_toolbar removeFromSuperview];
        [_popover dismissPopoverAnimated:NO];
        [self.view addSubview:_leftBarViewController.view];
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
    [_codeViewController showFile:file];
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
    [self.popover presentPopoverFromBarButtonItem:button
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}
@end
