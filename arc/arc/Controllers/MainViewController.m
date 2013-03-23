//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"
#import "ApplicationState.h"
#import "RootFolder.h"
#import "Folder.h"
#import "File.h"
#import "FileNavigationViewController.h"
#import "CodeViewController.h"
#import "Constants.h"

@interface MainViewController ()
@property CodeViewController *codeViewController;
@property FileNavigationViewController *fileNavigator;
@property RootFolder *rootFolder;
@end

@implementation MainViewController
@synthesize codeViewController = _codeViewController;
@synthesize fileNavigator = _fileNavigator;
@synthesize rootFolder = _rootFolder;

- (void)loadView
{
    [self setView:
     [[UIView alloc]
      initWithFrame:[[UIScreen mainScreen] bounds]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rootFolder = [RootFolder getInstance];
    NSArray *fileObjectsArray = [_rootFolder getContents];
    
    // Jerome (2013-03-23): logs all folders and files in the root.
    // Demonstrates that they exist.
    for (FileObject *currentObject in fileObjectsArray) {
        NSLog(@"%@", [currentObject name]);
        NSLog(@"Folder? %@", [currentObject isKindOfClass:[Folder class]] ? @"Yes" : @"No");
        NSLog(@"%@", [currentObject getContents]);
    }
    
    // TODO
    // this is temporary to glue the stuff together.
    // - ymichael
    _codeViewController = [[CodeViewController alloc] init];
    _codeViewController.delegate = self;
    _codeViewController.view.frame = SIZE_CODE_VIEW_PORTRAIT;
    
    _fileNavigator = [[FileNavigationViewController alloc] initWithFolder:_rootFolder];
    _fileNavigator.delegate = self;
    
    [self.view addSubview:_fileNavigator.view];
    [self.view addSubview:_codeViewController.view];
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
