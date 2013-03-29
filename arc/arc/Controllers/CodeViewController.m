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
#import "ApplicationState.h"
#import "ArcAttributedString.h"
#import "BasicStyles.h"
#import "SyntaxHighlight.h"
@interface CodeViewController ()
@property File *currentFile;
@property CoreTextUIView *codeView;
@property ArcAttributedString *arcAttributedString;
@end

@implementation CodeViewController
@synthesize delegate;
@synthesize codeView = _codeView;
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
    self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.scrollEnabled = YES;
    self.view.contentSize = CGSizeMake(768, 2000);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _codeView = [[CoreTextUIView alloc] init];
    [self.view addSubview:_codeView];
    _codeView.frame = self.view.bounds;
    
    // tmp
    [self showFile:[ApplicationState getSampleFile]];
}

- (void)showFile:(File*)file
{
    // Update Current file
    _currentFile = file;
    
    // Updated and Display relevant meta data
    // (filename, type, etc.)
    // TODO
    
    [self loadFile:_currentFile];
    
    // Middleware
    [[[BasicStyles alloc] init] execOn:_arcAttributedString FromFile:_currentFile];
    [[[SyntaxHighlight alloc] init] execOn:_arcAttributedString FromFile:_currentFile];
    
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
    [_codeView setAttributedString:_arcAttributedString.attributedString];
}

@end
