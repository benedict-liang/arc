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
        
        // tmp.
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
    _documentsNavigationViewController.toolbarHidden = NO;
    [self addChildViewController:_documentsNavigationViewController];
    
    // Settings View Controller
    _settingsNavigationViewController = [[UINavigationController alloc] init];
    _settingsNavigationViewController.toolbarHidden = NO;
    [self addChildViewController:_settingsNavigationViewController];
    
    // Actual Settings View
    [self bootstrapSettingsView];

    // Show Documents By default
    [self showDocuments:nil];
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

# pragma mark - Methods to Switch Between Document and Settings View

- (void)showSettings:(id)sender
{
    [self transitionToViewController:_settingsNavigationViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}

- (void)showDocuments:(id)sender
{
    [self transitionToViewController:_documentsNavigationViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromRight];
}

- (void)transitionToViewController:(UINavigationController *)nextViewController
                       withOptions:(UIViewAnimationOptions)options
{
    nextViewController.view.frame = self.view.bounds;
    [UIView transitionWithView:self.view
                      duration:0.65f
                       options:options
                    animations:^{
                        [_currentViewController.view removeFromSuperview];
                        [self.view addSubview:nextViewController.view];
                    }
                    completion:^(BOOL finished){
                        _currentViewController = nextViewController;
                    }];
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
//    if (_currentViewController != _documentsNavigationViewController) {
//        [self showDocuments:nil];
//    }    
    
    if ([Utils isEqual:[folder parent] and:_currentFolder]) {
        // Normal Folder selected
        [self pushFolderView:folder];
    } else if ([Utils isEqual:folder and:[_currentFolder parent]]) {
        // Back Button.
        // noop.
    } else {
        // Jump to Folder.
        
        // Clear stack of folderViewController
        [_documentsNavigationViewController popToRootViewControllerAnimated:NO];
        
        // Find path to root (excluding current folder and root)
        id<Folder> current = folder;
        NSMutableArray *pathToRootFolder = [NSMutableArray array];
        while ([current parent]) {
            [pathToRootFolder addObject:[current parent]];
            current = (id<Folder>)[current parent];
        }
        
        // Push folderViewController onto the stack (w/o animation)
        // reverse order.
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
    
    // Edit Button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:folderViewController action:@selector(toggleEdit:)];
    
    [folderViewController setToolbarItems:[NSArray arrayWithObjects:
                                           editButton,
                                           dropboxButton,
                                           [Utils flexibleSpace],
                                           settingsButton,
                                           nil]
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

@end
