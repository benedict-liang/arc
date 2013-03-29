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
#import "BasicStyles.h"
#import "SyntaxHighlight.h"
@interface CodeViewController ()
@property File *currentFile;
@property CoreTextUIView *codeView;
@property NSMutableAttributedString *attributedString;
@end

@implementation CodeViewController
@synthesize delegate;
@synthesize codeView = _codeView;
@synthesize currentFile = _currentFile;
@synthesize attributedString = _attributedString;

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
    [[[BasicStyles alloc] init] execOn:_attributedString FromFile:_currentFile];
    [[[SyntaxHighlight alloc] init] execOn:_attributedString FromFile:_currentFile];
    
    // Render Code to screen
    [self render];
}

- (void)loadFile:(File*)file
{
    // Create new NSMutableAttributed String for currentFile
    _attributedString = [[NSMutableAttributedString alloc]
                         initWithString:[_currentFile contents]];
}

- (void)render
{
    [_codeView setAttributedString:_attributedString];
}

@end
