//
//  DestinationFolderViewController.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DestinationFolderViewController.h"

@interface DestinationFolderViewController ()
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@end

@implementation DestinationFolderViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [self setUpTableView];
    [self setUpNavigationController];

    _closeButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(shouldClose:)];
    self.navigationItem.rightBarButtonItem = _closeButton;
}

- (void)setUpNavigationController
{
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *createFolderButton =
    [[UIBarButtonItem alloc] initWithTitle:@"New Folder"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(newFolder:)];
    UIBarButtonItem *selectFolderButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Select Folder"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(selectFolder:)];
    
    self.toolbarItems = @[
                          [Utils flexibleSpace],
                          createFolderButton,
                          selectFolderButton
                          ];
}

- (void)newFolder:(id)sender
{

}

- (void)selectFolder:(id)sender
{
    
}

- (void)shouldClose:(id)sender
{
    [self.delegate modalViewControllerDone:nil];
}

@end
