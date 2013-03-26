//
//  CodeViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "CodeViewController.h"
#import "ApplicationState.h"
#import "BasicStyles.h"
@interface CodeViewController ()
//
// Array of @selectors
//
// each @selector is called with
// - (NSAttributedString*) attributedString
// - (File*) currentFile
@property File *currentFile;
@property NSMutableAttributedString *attributedString;
@end

@implementation CodeViewController
@synthesize delegate;
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
    self.view = [[CoreTextUIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    // Render Code to screen
    [self render];
}

- (void)loadFile:(File*)file
{
    // Create new NSMutableAttributed String for currentFile
    _attributedString = [[NSMutableAttributedString alloc]
                         initWithString:[_currentFile getContents]];
}

- (void)render
{
    [self.view setAttributedString:_attributedString];
}

@end
