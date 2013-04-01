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

@interface LeftViewController ()
@property UIToolbar* toolbar;
@property UIViewController* currentViewController;
@property FileNavigationViewController* fileNavigationViewController;
@property SettingsViewController *settingsViewController;
- (void)showSettings:(id)sender;
- (void)showFileNavigator:(id)sender;
@end

@implementation LeftViewController
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
    }
    return self;
}

- (void)setDelegate:(id<MainViewControllerProtocol>)delegate
{
    _delegate = delegate;
    
    // Assign Delegate to ChildViewControllers
    for (id<SubViewControllerProtocol> childVC in self.childViewControllers) {
        childVC.delegate = delegate;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // File Navigator View Controller
    _fileNavigationViewController = [[FileNavigationViewController alloc] init];
    [self addChildViewController:_fileNavigationViewController];
    
    _settingsViewController = [[SettingsViewController alloc] init];
    [self addChildViewController:_settingsViewController];

    [self showFileNavigator:nil];

    _toolbar = [[UIToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, SIZE_TOOLBAR_HEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_toolbar];
    
    // Update toolbar
    [self updateToolBar];
}
- (void)updateToolBar
{
    UIBarButtonItem *button;
    if (_currentViewController == nil ||
        _currentViewController != _fileNavigationViewController) {
        button = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                  style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(showSettings:)];
    } else {
        button = [[UIBarButtonItem alloc] initWithTitle:@"Files"
                                                  style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(showFileNavigator:)];
    }
    _toolbar.items = [NSArray arrayWithObject:button];
}

- (void)showSettings:(id)sender
{
    [self transitionToViewController:_settingsViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromLeft];
    
    // Update toolbar
    [self updateToolBar];
}

- (void)showFileNavigator:(id)sender
{
    [self transitionToViewController:_fileNavigationViewController
                         withOptions:UIViewAnimationOptionTransitionFlipFromRight];
    
    // Update toolbar
    [self updateToolBar];
}

// Adapted from:
//http://stackoverflow.com/questions/8146253/animate-change-of-view-controllers-without-using-navigation-controller-stack-su
- (void)transitionToViewController:(UIViewController *)nextViewController
                       withOptions:(UIViewAnimationOptions)options
{
    nextViewController.view.frame = CGRectMake(
        self.view.bounds.origin.x, SIZE_TOOLBAR_HEIGHT,
        self.view.bounds.size.width, self.view.bounds.size.height);

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
