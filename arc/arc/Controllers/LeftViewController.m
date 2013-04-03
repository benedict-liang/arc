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
@property UIViewController *currentViewController;
@property UINavigationController *documentsNavigationViewController;
@property UINavigationController *settingsNavigationViewController;
@end

@implementation LeftViewController
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)setDelegate:(id<MainViewControllerProtocol>)delegate
{
    _delegate = delegate;
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
    
    // Show Documents By default
    [self showDocuments:nil];
}

- (void)showFolder:(id<Folder>)folder
{
    [self pushFolderView:folder];
}

// tmp hack
- (void)forceFolder:(id<Folder>)folder
{
    if (_currentViewController != _documentsNavigationViewController) {
        [self showDocuments:nil];
    }

    [_documentsNavigationViewController popToRootViewControllerAnimated:NO];
    
    id<Folder> current = folder;
    NSMutableArray *pathToRootFolder = [NSMutableArray array];
    while ([current parent]) {
        [pathToRootFolder addObject:current];
        current = (id<Folder>)[current parent];
    }
    
    id<Folder> parent;
    NSEnumerator *enumerator = [pathToRootFolder reverseObjectEnumerator];
    while (parent = [enumerator nextObject]) {
        [self pushFolderView:parent
                    animated:NO];
    }

}

- (void)pushFolderView:(id<Folder>)folder animated:(BOOL)animated
{
    // File Navigator View Controller
    FolderViewController *folderViewController =
    [[FolderViewController alloc] initWithFolder:folder];
    folderViewController.delegate = self.delegate;
    [_documentsNavigationViewController pushViewController:folderViewController
                                                  animated:animated];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(showSettings:)];
    
    UIBarButtonItem *dropbox = [[UIBarButtonItem alloc] initWithTitle:@"Dropbox"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(showDropBox:)];

    [folderViewController setToolbarItems:[NSArray arrayWithObjects:
                                           dropbox,
                                           flexibleSpace,
                                           button,
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

- (void)showSettings:(id)sender
{
    if (_settingsNavigationViewController.topViewController == nil) {
        SettingsViewController *settingsTableViewController = [[SettingsViewController alloc] init];
        settingsTableViewController.delegate = self.delegate;
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Documents"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(showDocuments:)];
        
        [settingsTableViewController
            setToolbarItems:[NSArray arrayWithObjects:flexibleSpace,button, nil]
            animated:YES];
        [_settingsNavigationViewController pushViewController:settingsTableViewController
                                           animated:YES];
    }

    [self transitionToViewController:_settingsNavigationViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}

- (NSString*)title
{
    return @"Documents";
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

@end
