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
@property UINavigationController *navigationController;
@property FileNavigationViewController* fileNavigationViewController;
@property SettingsViewController *settingsViewController;
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
    // Assign Delegates to ChildViewControllers
    _fileNavigationViewController.delegate = delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigationViewController];
}

- (void)setUpNavigationViewController
{
    _navigationController = [[UINavigationController alloc] init];
    _navigationController.toolbarHidden = NO;
    _navigationController.view.frame = self.view.bounds;
    [self.view addSubview:_navigationController.view];
}

- (void)showFolder:(id<Folder>)folder
{
    self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Custom Title"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
    
    // File Navigator View Controller
    FileNavigationViewController *fileNavigationViewController =
        [[FileNavigationViewController alloc] initWithFolder:folder];
    fileNavigationViewController.delegate = self.delegate;
    [_navigationController pushViewController:fileNavigationViewController
                                     animated:YES];
}


//- (void)transitionToViewController:(UIViewController *)nextViewController
//                       withOptions:(UIViewAnimationOptions)options
//{
//    nextViewController.view.frame = CGRectMake(
//        self.view.bounds.origin.x, SIZE_TOOLBAR_HEIGHT,
//        self.view.bounds.size.width, self.view.bounds.size.height);
//
//    [UIView transitionWithView:self.view
//                      duration:0.65f
//                       options:options
//                    animations:^{
//                        [_currentViewController.view removeFromSuperview];
//                        [self.view addSubview:nextViewController.view];
//                    }
//                    completion:^(BOOL finished){
//                        _currentViewController = nextViewController;
//                    }];
//}

@end
