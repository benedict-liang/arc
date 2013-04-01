//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property id<CodeViewControllerProtocol> codeViewController;
@property id<LeftViewControllerProtocol> leftViewController;

- (void)fileSelected:(id<File>)file;
- (void)folderSelected:(id<Folder>)folder;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _leftViewController = [self.viewControllers objectAtIndex:0];
    _codeViewController = [self.viewControllers objectAtIndex:1];

    // TMP
    [self fileSelected:[ApplicationState getSampleFile]];
    [self folderSelected:[RootFolder sharedRootFolder]];
}

// Shows the file using the CodeViewController
- (void)fileSelected:(id<File>)file
{
    // TODO
    // Register with Application State

    [_codeViewController showFile:file];
}

// Updates Current Folder being Viewed
- (void)folderSelected:(id<Folder>)folder
{
    // TODO
    // Register with Application State

    [_leftViewController showFolder:folder];
}

#pragma mark - MainViewControllerDelegate Methods

- (void)showLeftBar
{
    // TODO
}
- (void)hideLeftBar
{
    // TODO
}

- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject;
{
    if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        [self folderSelected:(id<Folder>)fileSystemObject];
    } else {
        [self fileSelected:(id<File>)fileSystemObject];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISplitViewController iOS 5.1 Compatibility (Rotation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
