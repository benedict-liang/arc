//
//  MasterViewController.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *tb = [[UIToolbar alloc] init];
    tb.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    [self.view addSubview:tb];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:0x27/255.0f
                                        green:0x28/255.0f
                                         blue:0x21/255.0f
                                        alpha:1];
    v.frame = tb.bounds;
    [tb addSubview:v];
}

@end
