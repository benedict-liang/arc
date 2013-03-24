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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setupFileNavWithFolder:(Folder*)folder {
    _fileNav = [[FileNavigationViewController alloc] initWithFolder:folder frame:SIZE_FILENAV_VIEW_PORTRAIT];
    _navController = [[UINavigationController alloc] initWithRootViewController:_fileNav];
    [self setView:_navController.view];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
