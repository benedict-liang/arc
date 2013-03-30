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
@property LeftViewController *leftViewController;

@property RootFolder *rootFolder;
@property UIToolbar *toolbar;
@property UIPopoverController *popover;
@end

@implementation MainViewController
@synthesize codeViewController = _codeViewController;
@synthesize leftViewController = _leftViewController;
@synthesize rootFolder = _rootFolder;

- (id)init
{
    self = [super init];
    if (self) {
        // tmp. should use application state
        _rootFolder = [RootFolder sharedRootFolder];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _leftViewController = [self.viewControllers objectAtIndex:0];
    _codeViewController = [self.viewControllers objectAtIndex:1];

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
    // tmp
    [_codeViewController showFile:[ApplicationState getSampleFile]];
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

// popover click callback
-(void)triggerPopover:(UIBarButtonItem*)button {
    [self.popover presentPopoverFromBarButtonItem:button
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}
@end
