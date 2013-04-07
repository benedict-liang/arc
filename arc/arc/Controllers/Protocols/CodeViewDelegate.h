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

@protocol CodeViewDelegate <NSObject>
- (void)showFile:(id<File>)file;
- (void)refreshForSetting:(NSString*)setting;
- (void)mergeAndRenderWith:(ArcAttributedString *)arcAttributedString
                   forFile:(id<File>)file
                WithStyle:(NSDictionary*)style;


// Register Plugin with CodeViewDelegate;
- (void)registerPlugin:(id<PluginDelegate>)plugin;

# pragma mark - Code View Properties
@property (nonatomic, strong) UIColor *backgroundColor;
@end

