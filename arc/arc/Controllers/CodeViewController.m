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

    CGColorRef color = [UIColor grayColor].CGColor;
    CTFontRef font = CTFontCreateWithName(CFSTR("Source Code Pro"), 40.0, NULL);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    // Font
                                    (__bridge id)font, (id)kCTFontAttributeName,

                                    // Color
                                    color, (id)kCTForegroundColorAttributeName,
                                    nil
                                ];
    
    NSString *str = @"(define arc '(arc reads code))";
    NSAttributedString * string = [[NSMutableAttributedString alloc]
                                   initWithString:str
                                   attributes:attributes];
    [self.view setAttributedString:string];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
