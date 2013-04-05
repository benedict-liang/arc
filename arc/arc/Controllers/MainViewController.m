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
}

- (void)viewWillAppear:(BOOL)animated
{
    ApplicationState *appState = [ApplicationState sharedApplicationState];
    [self fileSelected:[appState currentFileOpened]];
    [self folderSelected:[appState currentFolderOpened]];
}

// tmp
- (void)openIn:(id<File>)file
{
    [_leftViewController forceFolder:(id<Folder>)[file parent]];
    [self fileSelected:file];
}

- (void)dropboxAuthentication
{
    DBAccountManager *dbAccountManager = [DBAccountManager sharedManager];
    DBAccount *dbAccount = dbAccountManager.linkedAccount;
    if (!dbAccount) {
        // Link to the main view controller instance here.
        [dbAccountManager linkFromController:self];
    }
}

- (void)refreshCodeViewForSetting:(NSString *)setting
{
    [_codeViewController refreshForSetting:setting];
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

- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject;
{
    ApplicationState *appState = [ApplicationState sharedApplicationState];
    if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        [self folderSelected:(id<Folder>)fileSystemObject];
        [appState setCurrentFolderOpened:(id<Folder>)fileSystemObject];
    } else {
        [self fileSelected:(id<File>)fileSystemObject];
        [appState setCurrentFileOpened:(id<File>)fileSystemObject];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISpiltViewControllerDelegate Methods

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    [_codeViewController showShowMasterViewButton:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [_codeViewController hideShowMasterViewButton:barButtonItem];
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
