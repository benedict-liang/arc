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
#import "FoldNode.h"
#import "CodeFolding.h"
#import "OverlapPeekResult.h"
#import "SyntaxPatterns.h"
#import "SyntaxMatchStore.h"
//Immutable class. Holds thread local state

@interface SyntaxHighlight : NSObject <SyntaxHighlightDelegate> {

}


@property (nonatomic, weak) id<CodeViewControllerDelegate> delegate;
@property (nonatomic, weak) id<SyntaxHighlightingPluginDelegate> factory;
@property (nonatomic, readonly) id<File> currentFile;
@property (nonatomic, readonly) NSString* content;
@property (nonatomic, readonly) NSDictionary* bundle;
@property (nonatomic, strong) NSArray* overlays;
@property (readonly) NSArray* splitContent;
@property (strong) FoldTree* foldTree;
@property NSArray* foldStarts;
@property NSArray* foldEnds;
@property NSArray* foldRanges;
@property ArcAttributedString* finalOutput;
@property SyntaxPatterns* syntaxPatterns;

- (id)initWithFile:(id<File>)file
       andDelegate:(id<CodeViewControllerDelegate>)delegate;

- (void)execOn:(NSDictionary*)options;
- (void)renderOn:(NSDictionary*)options;
- (void)kill;
@end
