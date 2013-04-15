//
//  DetailViewController.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizesSubviews = YES;
    
    UIToolbar *tb = [[UIToolbar alloc] init];
    tb.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    tb.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tb];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:0x19/255.0f
                                        green:0x19/255.0f
                                         blue:0x19/255.0f
                                        alpha:1];
    v.frame = tb.bounds;
    tb.autoresizesSubviews = YES;
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [tb addSubview:v];
}

@end
