//
//  CreateFolderViewController.m
//  arc
//
//  Created by Jerome Cheng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CreateFolderViewController.h"

@interface CreateFolderViewController ()

@end

@implementation CreateFolderViewController

- (void)loadView
{
    [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)]];
    
    UILabel *createFolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    [createFolderLabel setText:@"Enter folder name:"];
    UITextField *folderNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 300, 100)];
    [[self view] addSubview:createFolderLabel];
    [[self view] addSubview:folderNameField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
