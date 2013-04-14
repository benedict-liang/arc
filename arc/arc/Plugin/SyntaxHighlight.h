//
//  SyntaxHighlight.h
//  arc
//
//  Created by omer iqbal on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "TMBundleHeader.h"
#import "CodeViewControllerDelegate.h"
#import "File.h"
#import "Utils.h"
#import "FoldTree.h"
#import "SyntaxHighlightingPluginDelegate.h"

//Immutable class. Holds thread local state

@interface SyntaxHighlight : NSObject {
    __block NSDictionary *nameMatches;
    __block NSDictionary *captureMatches;
    __block NSDictionary *beginCMatches;
    __block NSDictionary *endCMatches;
    __block NSDictionary *pairMatches;
    __block NSDictionary *contentNameMatches;
    __block NSDictionary *overlapMatches;
    __block NSArray *foldRanges;
}


@property (nonatomic, readonly) id<CodeViewControllerDelegate> delegate;
@property (nonatomic, weak) id<SyntaxHighlightingPluginDelegate> factory;
@property (nonatomic, readonly) id<File> currentFile;
@property (nonatomic, readonly) NSString* content;
@property (nonatomic, readonly) NSDictionary* bundle;
@property (nonatomic, strong) NSArray* overlays;
@property (readonly) NSArray* splitContent;

@property NSArray* foldStarts;
@property NSArray* foldEnds;
- (id)initWithFile:(id<File>)file
       andDelegate:(id<CodeViewControllerDelegate>)delegate;

- (void)execOn:(NSDictionary*)options;
- (void)kill;
@end
