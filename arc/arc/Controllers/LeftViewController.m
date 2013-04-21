//
//  LeftBarViewController.m
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"
#import "LeftViewController.h"
#import "FolderViewController.h"
#import "SettingsViewController.h"
#import "RootFolder.h"

@interface LeftViewController ()
@property (nonatomic, strong) id<Folder> currentFolder;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *documentsNavigationViewController;
@property (nonatomic, strong) UINavigationController *settingsNavigationViewController;
@property (nonatomic, strong) SettingsViewController *settingsViewController;
- (void)bootstrapSettingsView;
@end

@implementation LeftViewController
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.view.clipsToBounds = YES;
        self.title = @"Documents";
    }
    return self;
}

- (void)setDelegate:(id<MainViewControllerDelegate>)delegate
{
    _delegate = delegate;
    _settingsViewController.delegate = delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // File Navigator
    _documentsNavigationViewController = [[UINavigationController alloc] init];
    _documentsNavigationViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Document"
                                      image:[Utils scale:[UIImage imageNamed:@"documents.png"]
                                                  toSize:CGSizeMake(40, 30)]
                                        tag:TAB_DOCUMENTS];
    _documentsNavigationViewController.view.autoresizesSubviews = YES;
    
//    [_documentsNavigationViewController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor], UITextAttributeTextColor,
//      [UIColor colorWithRed:0 green:0 blue:0 alpha:0], UITextAttributeTextShadowColor,
//      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//      [UIFont fontWithName:@"Helvetica Neue" size:0.0], UITextAttributeFont,
//      nil]];
    
    [self addChildViewController:_documentsNavigationViewController];
    
    // Settings View Controller
    _settingsNavigationViewController = [[UINavigationController alloc] init];
    _settingsNavigationViewController.view.autoresizesSubviews = YES;
    _settingsNavigationViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Setting"
                                      image:[Utils scale:[UIImage imageNamed:@"settings.png"]
                                                  toSize:CGSizeMake(30, 30)]
                                        tag:TAB_SETTINGS];
    // Actual Settings View
    [self bootstrapSettingsView];
    [self addChildViewController:_settingsNavigationViewController];

    // Dropbox
    UIViewController *dropbox = [[UIViewController alloc] init];
    dropbox.tabBarItem = [[UITabBarItem alloc]
                          initWithTitle:@"Dropbox"
                          image:[Utils scale:[UIImage imageNamed:@"dropbox.png"]
                                      toSize:CGSizeMake(40, 40)]
                          tag:TAB_DROPBOX];

    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.delegate = self;
    _tabBarController.view.frame = self.view.bounds;
    _tabBarController.view.autoresizesSubviews = YES;
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:
                                           _documentsNavigationViewController,
                                           dropbox,
                                           _settingsNavigationViewController,
                                           nil]];
    
    [self.view addSubview:_tabBarController.view];
}

- (void)bootstrapSettingsView
{
    _settingsViewController = [[SettingsViewController alloc] init];
    _settingsViewController.delegate = self.delegate;    
    [_settingsNavigationViewController pushViewController:_settingsViewController
                                                 animated:YES];
}

# pragma mark - SettingsViewDelegate Methods

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // delegate to actual settings view controller
    [_settingsViewController registerPlugin:plugin];
}

# pragma mark - FileNavigatorViewController Delegate Methods

- (void)navigateTo:(id<Folder>)folder
{
    // Force Document View
    [self showDocuments:nil];
    
    if ([Utils isEqual:[folder parent]
                   and:_currentFolder]) {
        // Normal Folder selected
        [self pushFolderView:folder];
    } else if ([Utils isEqual:folder
                          and:[_currentFolder parent]]) {
        // Back Button.
        // Refresh folder contents
        FolderViewController *folderViewController =
            (FolderViewController*) _documentsNavigationViewController.visibleViewController;
        [folderViewController refreshFolderView];
    } else {
        // Jump to Folder.
        // (no logical way to "animate" to folder"
        
        // Clear stack of folderViewController
        [_documentsNavigationViewController popToRootViewControllerAnimated:NO];
        
        // Find path to root
        // (excluding current folder and root)
        id<Folder> current = folder;
        NSMutableArray *pathToRootFolder = [NSMutableArray array];
        while ([current parent]) {
            [pathToRootFolder addObject:[current parent]];
            current = (id<Folder>)[current parent];
        }
        
        // Push folderViewController onto the stack
        // in reverse order. (w/o animation)
        id<Folder> parent;
        NSEnumerator *enumerator = [pathToRootFolder reverseObjectEnumerator];
        while (parent = [enumerator nextObject]) {
            [self pushFolderView:parent
                        animated:NO];
        }
        
        // push folder to navigate to.
        [self pushFolderView:folder];
    }
    
    // Update current folder.
    _currentFolder = folder;
}

- (void)pushFolderView:(id<Folder>)folder
              animated:(BOOL)animated
{
    // File Navigator View Controller
    FolderViewController *folderViewController =
        [[FolderViewController alloc] initWithFolder:folder];
    folderViewController.folderViewControllerDelegate = self;
    folderViewController.delegate = self.delegate;
    [_documentsNavigationViewController pushViewController:folderViewController
                                                  animated:animated];
}

- (void)pushFolderView:(id<Folder>)folder
{
    [self pushFolderView:folder animated:YES];
}

- (void)showDropBox:(id)sender
{
    [self.delegate dropboxAuthentication];
}

# pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == TAB_DROPBOX) {
        [self showDropBox:nil];
        return NO;
    }  else {
        return YES;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isEqual:_settingsNavigationViewController]) {
        [_settingsNavigationViewController popToRootViewControllerAnimated:YES];
    }
}

- (void)showSettings:(id)sender
{
    [self tabBarController:_tabBarController
   didSelectViewController:_settingsNavigationViewController];
}

- (void)showDocuments:(id)sender
{
    [self tabBarController:_tabBarController
   didSelectViewController:_documentsNavigationViewController];
}

# pragma mark - Folder View Controller Delegate

- (void)folderViewController:(FolderViewController*)folderviewController
     DidEnterEditModeAnimate:(BOOL)animate
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self hideTabBar:_tabBarController];
                     }
                     completion:^(BOOL finished){
                         [folderviewController editActionTriggeredAnimate:NO];
                     }];
}

- (void)folderViewController:(FolderViewController*)folderviewController DidExitEditModeAnimate:(BOOL)animate
{
    [folderviewController editActionTriggeredAnimate:NO];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        [self showTabBar:_tabBarController];
                     }
                     completion:^(BOOL finished){}];
}

# pragma mark - tmp code
// copied from SO.
// http://stackoverflow.com/questions/5272290/how-to-hide-uitabbarcontroller

- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    for (UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x,
                                      self.view.frame.size.height,
                                      view.frame.size.width,
                                      view.frame.size.height)];
        } else {
            [view setFrame:self.view.bounds];
            view.backgroundColor = [UIColor blackColor];
        }
    }
}

- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    float fHeight = tabbarcontroller.tabBar.frame.size.height;
    for (UIView *view in tabbarcontroller.view.subviews) {        
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x,
                                      self.view.frame.size.height - fHeight,
                                      view.frame.size.width,
                                      view.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      self.view.frame.size.height - fHeight)];
        }
    }
}

@end
