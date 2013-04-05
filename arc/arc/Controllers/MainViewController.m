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
@property BOOL hideLeftView;
- (void)fileSelected:(id<File>)file;
- (void)folderSelected:(id<Folder>)folder;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        _hideLeftView = NO;
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
    [self fileSelected:[ApplicationState getSampleFile]];
    [self folderSelected:[RootFolder sharedRootFolder]];
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

- (void)showLeftBar
{
    _hideLeftView = NO;
    [self.view setNeedsLayout];
}
- (void)hideLeftBar
{
    _hideLeftView = YES;
    [self.view setNeedsLayout];
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

#pragma mark - UISpiltViewControllerDelegate Methods

//- (BOOL)splitViewController:(UISplitViewController *)svc
//   shouldHideViewController:(UIViewController *)vc
//              inOrientation:(UIInterfaceOrientation)orientation
//{
//    NSLog(@"asdf");
//    return _hideLeftView;
//}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{

    barButtonItem.title = [((LeftViewController*) aViewController) title];
    [((CodeViewController*)_codeViewController) toolbar].items = [NSArray arrayWithObject:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    CodeViewController *codeViewController = (CodeViewController*) _codeViewController;
    codeViewController.toolbar.items = [NSArray array];
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
