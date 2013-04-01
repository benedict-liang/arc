//
//  LeftBarViewController.m
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"
#import "LeftViewController.h"
#import "FileNavigationViewController.h"
#import "SettingsViewController.h"

#import "RootFolder.h"

@interface LeftViewController ()
@property id<Folder> currentFolder;
@property UIViewController *currentViewController;
@property UINavigationController* fileNavigationViewController;
@property UINavigationController *settingsViewController;
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
    _fileNavigationViewController = [[UINavigationController alloc] init];
    _fileNavigationViewController.toolbarHidden = NO;
    [self addChildViewController:_fileNavigationViewController];
    
    // Settings View Controller
    _settingsViewController = [[UINavigationController alloc] init];
    _settingsViewController.toolbarHidden = NO;
    [self addChildViewController:_settingsViewController];
    
    [self showDocuments:nil];
}

- (void)showFolder:(id<Folder>)folder
{    
    // File Navigator View Controller
    FileNavigationViewController *fileNavigationViewController =
        [[FileNavigationViewController alloc] initWithFolder:folder];
    fileNavigationViewController.delegate = self.delegate;
    [_fileNavigationViewController pushViewController:fileNavigationViewController
                                     animated:YES];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];

    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(showSettings:)];

    [fileNavigationViewController setToolbarItems:[NSArray arrayWithObjects:flexibleSpace,button, nil]
                                         animated:YES];
}

- (void)showSettings:(id)sender
{
    if (_settingsViewController.topViewController == nil) {
        SettingsViewController *settingsTableViewController = [[SettingsViewController alloc] init];
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
        [_settingsViewController pushViewController:settingsTableViewController
                                           animated:YES];
    }

    [self transitionToViewController:_settingsViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}

- (void)showDocuments:(id)sender
{
    [self transitionToViewController:_fileNavigationViewController
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
