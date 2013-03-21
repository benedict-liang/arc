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
    NSArray *fileObjectsArray = [rootFolder contents];
    
    _codeViewController = [[CodeViewController alloc] init];
    _codeViewController.delegate = self;
    //poor man's unit test :P
    _fileNavigator = [[FileNavigationViewController alloc] initWithFiles:@[@"test1",@"test2"]];
    [self.view addSubview:_fileNavigator.view];
}

- (void)showFile:(File*)file {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
