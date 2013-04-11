//
//  ArcViewController.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ArcViewController.h"
#import "ArcShadowView.h"

@interface ArcViewController ()

@end

@implementation ArcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.width)];
    left.layer.cornerRadius = 10;
    left.layer.masksToBounds = YES;
    left.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:left];
    

    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.bounds.size.height - 100, self.view.bounds.size.width)];
    right.layer.cornerRadius = 10;
    right.layer.masksToBounds = NO;
    right.backgroundColor = [UIColor whiteColor];
    right.layer.shadowRadius = 5;
    right.layer.shadowOpacity = 0.5;
    [self.view addSubview:right];
}

@end
