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
@property (nonatomic, strong) UIViewController *currentViewController;
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
                                        tag:0];
    _documentsNavigationViewController.toolbarHidden = YES;
    [self addChildViewController:_documentsNavigationViewController];
    
    // Settings View Controller
    _settingsNavigationViewController = [[UINavigationController alloc] init];
    _settingsNavigationViewController.toolbarHidden = NO;
    _settingsNavigationViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:@"Setting"
                                      image:[Utils scale:[UIImage imageNamed:@"settings.png"]
                                                  toSize:CGSizeMake(30, 30)]
                                        tag:0];
    [self addChildViewController:_settingsNavigationViewController];
    
    // Actual Settings View
    [self bootstrapSettingsView];

    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.delegate = self;
    _tabBarController.view.frame = self.view.bounds;
    _tabBarController.view.autoresizesSubviews = YES;
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:
                                       _documentsNavigationViewController,
                                       _settingsNavigationViewController,
                                       nil]];

    [self.view addSubview:_tabBarController.view];
}

- (void)bootstrapSettingsView
{
    _settingsViewController = [[SettingsViewController alloc] init];
    _settingsViewController.delegate = self.delegate;
    UIBarButtonItem *button =
    [[UIBarButtonItem alloc] initWithTitle:@"Documents"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(showDocuments:)];
    
    [_settingsViewController setToolbarItems:[NSArray arrayWithObjects:
                                              [Utils flexibleSpace],
                                              button,
                                              nil]
                                    animated:YES];
    
    [_settingsNavigationViewController pushViewController:_settingsViewController
                                                 animated:YES];
}

# pragma mark - UITabBarControllerDelegate

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

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    viewController.view.frame = tabBarController.view.bounds;
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
    if (_currentViewController != _documentsNavigationViewController) {
        [self showDocuments:nil];
    }
    
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
        [folderViewController refreshFolderContents];
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

- (void)pushFolderView:(id<Folder>)folder animated:(BOOL)animated
{
    // File Navigator View Controller
    FolderViewController *folderViewController =
        [[FolderViewController alloc] initWithFolder:folder];
    folderViewController.delegate = self.delegate;
    
    [_documentsNavigationViewController pushViewController:folderViewController
                                                  animated:animated];

    // Settings Button
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(showSettings:)];
    
    // DropBox Button
    UIImage *dropBoxIcon = [Utils scale:[UIImage imageNamed:@"dropbox.png"]
                                 toSize:CGSizeMake(SIZE_TOOLBAR_ICON_WIDTH, SIZE_TOOLBAR_ICON_WIDTH)];;
    UIBarButtonItem *dropboxButton = [[UIBarButtonItem alloc] initWithImage:dropBoxIcon
                                                        landscapeImagePhone:dropBoxIcon
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showDropBox:)];
    
    [folderViewController setToolbarItems:[NSArray arrayWithObjects:
                                           dropboxButton,
                                           [Utils flexibleSpace],
                                           settingsButton,
                                           nil]
                                 animated:animated];
    
    // Edit Button
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                     style:UIBarButtonItemStyleBordered
                                    target:folderViewController
                                    action:@selector(toggleEdit:)];
    
    folderViewController.navigationItem.rightBarButtonItem = editButton;

}

- (void)pushFolderView:(id<Folder>)folder
{
    [self pushFolderView:folder animated:YES];
}

- (void)showDropBox:(id)sender
{
    [self.delegate dropboxAuthentication];
}

@end
