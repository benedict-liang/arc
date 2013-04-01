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
@property id<File> currentFile;
@property CoreTextUIView *coreTextView;
@property ArcAttributedString *arcAttributedString;
- (void)refreshSubViewSizes;
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

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshSubViewSizes];
}

- (void)refreshSubViewSizes
{
    [_coreTextView refresh];

    // Resize codeView (parent) Content Size
    self.view.contentSize = _coreTextView.bounds.size;
}

- (void)showFile:(id<File>)file
{
    // Update Current file
    _currentFile = file;
    [self loadFile:_currentFile];


    // Middleware to Style Attributed String
    [BasicStyles arcAttributedString:_arcAttributedString
                              OfFile:_currentFile
                            delegate:self];
    [SyntaxHighlight arcAttributedString:_arcAttributedString
                                  OfFile:_currentFile
                                delegate:self];

    // Render Code to screen
    [self render];
    
    // Update Sizes of SubViews
    [self refreshSubViewSizes];
}

- (void)loadFile:(id<File>)file
{
    _arcAttributedString = [[ArcAttributedString alloc]
                            initWithString:[_currentFile contents]];
}

- (void)mergeAndRenderWith:(ArcAttributedString*)aas forFile:(id<File>)file
{
    //TODO merge aas with _arcAttributedString.
    if ([file isEqual:_currentFile]) {
        _arcAttributedString = aas;
        [self render];
    }
}
- (void)render
{
    [_coreTextView setAttributedString:_arcAttributedString.attributedString];
}
@end
