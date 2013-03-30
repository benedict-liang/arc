//
//  LeftBarViewController.m
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LeftBarViewController.h"

@interface LeftBarViewController ()

@end

@implementation LeftBarViewController
@synthesize delegate;

- (id)initWithFolder:(Folder*)folder delegate:(id)del{
    self = [super init];
    if (self) {
        self.delegate = del;
        [self setupFileNavWithFolder:folder];
    }
    return self;
}
- (void)setupFileNavWithFolder:(Folder*)folder {
    _fileNav = [[FileNavigationViewController alloc] initWithFolder:folder frame:self.view.bounds];
    _fileNav.delegate = self.delegate;
    _navController = [[UINavigationController alloc] initWithRootViewController:_fileNav];
    [self.view addSubview:_navController.view];
    [self.view addSubview:_fileNav.view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

}
@end
