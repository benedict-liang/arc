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
    _fileSystem = [FileSystem getInstance];
    Folder *rootFolder = [_fileSystem getRootFolder];
    NSArray *fileObjectsArray = [rootFolder getFiles];
    
//    _codeViewController =
    FileNavigationViewController *fileNavigator = [[FileNavigationViewController alloc] initWithFiles:fileObjectsArray];
}

- (void)showFile:(File*)file {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
