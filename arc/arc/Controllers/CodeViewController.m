//
//  CodeViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "CodeViewController.h"
@interface CodeViewController ()
@end

@implementation CodeViewController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    self.view = [[CoreTextUIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *str = @"(define arc '(arc reads code))";
    
    UIFont *font = [UIFont fontWithName:@"Source Code Pro" size:50.0f];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];

    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor grayColor]
                   range:NSMakeRange(0,str.length)];
    
    [string addAttribute:NSFontAttributeName
                   value:font
                   range:NSMakeRange(0,str.length)];
    
    [self.view setAttributedString:string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
