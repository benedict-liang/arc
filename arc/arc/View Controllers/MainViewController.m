//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)loadView
{
    [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rootFolder = [RootFolder getInstance];
    NSArray *fileObjectsArray = [_rootFolder getContents];
    
    _codeViewController = [[CodeViewController alloc] init];
    _codeViewController.delegate = self;
    //poor man's unit test :P
    _fileNavigator = [[FileNavigationViewController alloc] initWithFiles:@[@"test1",@"test2"]];
    _fileNavigator.delegate = self;
    
    [self.view addSubview:_fileNavigator.view];
}

#pragma mark - MainViewControllerDelegate Methods

// Shows the file using the CodeViewController
- (void)showFile:(File*)file {

}

// Updates the FileNavigatorViewController view after adding a folder
- (void)updateAddFolderView:(Folder*)folder {
    
}

// Updates the FileNavigatorViewController view after adding a file
- (void)updateAddFileView:(File*)file {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
