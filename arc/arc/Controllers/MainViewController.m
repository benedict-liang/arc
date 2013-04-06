//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"

// Plugins
#import "SyntaxHighlightingPlugin.h"
#import "FontFamilyPlugin.h"
#import "FontSizePlugin.h"

@interface MainViewController ()
@property CodeViewController *codeViewController;
@property LeftViewController *leftViewController;
@property NSArray *plugins;
- (void)fileSelected:(id<File>)file;
- (void)folderSelected:(id<Folder>)folder;
- (void)registerPlugins;
- (void)registerPlugin:(id<PluginDelegate>)plugin;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        _plugins = [NSArray arrayWithObjects:
//                    [SyntaxHighlightingPlugin class],
                    [[FontFamilyPlugin alloc] init],
                    [[FontSizePlugin alloc] init],
                    nil];
    }
    return self;
}

- (void)registerPlugins
{
    for (id<PluginDelegate> plugin in _plugins) {
        [self registerPlugin:plugin];
    }
}

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // TODO.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _leftViewController = [self.viewControllers objectAtIndex:0];
    _codeViewController = [self.viewControllers objectAtIndex:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Work Around to trigger delegate and show document button in uitoolbar.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

    ApplicationState *appState = [ApplicationState sharedApplicationState];
    [self fileSelected:[appState currentFileOpened]];
    [self folderSelected:[appState currentFolderOpened]];
}

// tmp
- (void)openIn:(id<File>)file
{
    [_leftViewController navigateTo:(id<Folder>)[file parent]];
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

#pragma mark - MainViewControllerDelegate Methods

- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject;
{
    if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        [self folderSelected:(id<Folder>)fileSystemObject];
    } else {
        [self fileSelected:(id<File>)fileSystemObject];
    }
}

// Shows the file using the CodeViewController
- (void)fileSelected:(id<File>)file
{
 ApplicationState *appState = [ApplicationState sharedApplicationState];
  [appState setCurrentFileOpened:file];
    [_codeViewController showFile:file];
}

// Updates Current Folder being Viewed
- (void)folderSelected:(id<Folder>)folder
{
    ApplicationState *appState = [ApplicationState sharedApplicationState];
    [appState setCurrentFolderOpened:folder];
    [_leftViewController navigateTo:folder];
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
