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


- (void)fileSelected:(id<File>)file;
- (void)folderSelected:(id<Folder>)folder;

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

    // tmp
    [_codeViewController showFile:[ApplicationState getSampleFile]];
}

// Shows the file using the CodeViewController
- (void)fileSelected:(id<File>)file
{
    [_codeViewController showFile:file];
}

// Updates Current Folder being Viewed
- (void)folderSelected:(id<Folder>)folder
{
    // TODO
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

- (void)fileObjectSelected:(id<FileSystemObject>)fileObject
{
    if ([[fileObject class] conformsToProtocol:@protocol(Folder)]) {
        [self folderSelected:(id<Folder>)fileObject];
    } else {
        [self fileSelected:(id<File>)fileObject];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// popover click callback
-(void)triggerPopover:(UIBarButtonItem*)button {
    [self.popover presentPopoverFromBarButtonItem:button
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
