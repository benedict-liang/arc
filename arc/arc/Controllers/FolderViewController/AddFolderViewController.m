//
//  AddFolderViewController.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AddFolderViewController.h"

@interface AddFolderViewController ()

@end

@implementation AddFolderViewController
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Create a Folder";
    
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancel:(id)sender
{
    [self.delegate modalViewControllerDone:
     [FolderCommandObject commandOfType:kCancelCommand
                             withTarget:nil]];
}

@end
