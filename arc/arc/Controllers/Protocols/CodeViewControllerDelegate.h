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

@protocol CodeViewControllerDelegate <NSObject>
- (void)showFile:(id<File>)file;
- (void)scrollToLineNumber:(int)lineNumber;
- (void)refreshForSetting:(NSString*)setting;
- (void)registerPlugin:(id<PluginDelegate>)plugin;
- (void)mergeAndRenderWith:(ArcAttributedString *)arcAttributedString
                   forFile:(id<File>)file
                WithStyle:(NSDictionary*)style;
- (void)setBackgroundColorForString:(UIColor*)color
                          WithRange:(NSRange)range
                         forSetting:(NSString*)setting;
- (NSString*)getStringForRange:(NSRange)range;

@end

