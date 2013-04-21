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
    
    _closeButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(shouldClose:)];
    self.navigationItem.rightBarButtonItem = _closeButton;
}

- (void)shouldClose:(id)sender
{
    [self.delegate modalViewControllerDone:nil];
}

@end
