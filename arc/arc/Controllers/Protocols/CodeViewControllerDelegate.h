//
//  CodeViewDelegate.h
//  arc
//
//  Created by omer iqbal on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "PluginDelegate.h"
#import "File.h"
#import "FoldTree.h"

@protocol CodeViewControllerDelegate <NSObject>
- (void)showFile:(id<File>)file;
- (void)scrollToLineNumber:(int)lineNumber;
- (void)refreshForSetting:(NSString*)setting;
- (void)registerPlugin:(id<PluginDelegate>)plugin;
- (NSString*)getStringForRange:(NSRange)range;
- (void)removeBackgroundColorForSetting:(NSString*)setting;
- (void)mergeAndRenderWith:(ArcAttributedString *)arcAttributedString
                   forFile:(id<File>)file
                 WithStyle:(NSDictionary*)style
                   AndTree:(FoldTree*)foldTree;

- (void)setBackgroundColorForString:(UIColor*)color
                          WithRange:(NSRange)range
                         forSetting:(NSString*)setting;

// TODO: Need to apply this somewhere else, but this works
// fine for prototyping
- (void)dismissTextSelectionViews;
- (void)redrawCodeViewBoundsChanged:(BOOL)boundsChanged;
@end

