//
//  CodeViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "CodeViewController.h"
#import "CoreTextUIView.h"
#import "ArcAttributedString.h"
#import "BasicStyles.h"
#import "SyntaxHighlight.h"
@interface CodeViewController ()
@property File *currentFile;
@property CoreTextUIView *coreTextView;
@property ArcAttributedString *arcAttributedString;
@end

@implementation CodeViewController
@synthesize delegate;
@synthesize coreTextView = _coreTextView;
@synthesize currentFile = _currentFile;
@synthesize arcAttributedString = _arcAttributedString;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    self.view = [[CodeView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _coreTextView = [[CoreTextUIView alloc] init];
    [self.view addSubview:_coreTextView];
    _coreTextView.frame = self.view.bounds;
}

- (void)showFile:(File*)file
{
    // Update Current file
    _currentFile = file;
    [self loadFile:_currentFile];


    // Middleware to Style Attributed String
    [BasicStyles arcAttributedString:_arcAttributedString
                              OfFile:_currentFile];
//    [SyntaxHighlight arcAttributedString:_arcAttributedString
//                                  OfFile:_currentFile];

    // Render Code to screen
    [self render];
}

- (void)loadFile:(File*)file
{
    _arcAttributedString = [[ArcAttributedString alloc]
                            initWithString:[_currentFile contents]];
}

- (void)render
{
    [_coreTextView setAttributedString:_arcAttributedString.attributedString];
    
    // Resize codeView (parent) Content Size
    self.view.contentSize = _coreTextView.bounds.size;
}

@end
