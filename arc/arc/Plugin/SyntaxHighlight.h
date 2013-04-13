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

@property (readonly) id<CodeViewControllerDelegate> delegate;
@property (readonly) id<File> currentFile;
@property (readonly) NSString* content;
@property (readonly) NSDictionary* bundle;
@property (readonly) NSArray* splitContent;
@property NSArray* overlays;
@property BOOL isProcessed;

@property NSArray* foldStarts;
@property NSArray* foldEnds;

- (id)initWithFile:(id<File>)file del:(id<CodeViewControllerDelegate>)delegate;
- (void)execOn:(NSDictionary*)options;
- (void)reapplyWithOpts:(NSDictionary*)options;

@end
