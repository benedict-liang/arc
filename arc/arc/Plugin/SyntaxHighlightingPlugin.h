//
//  SyntaxHighlightingPlugin.h
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PluginDelegate.h"
#import "ArcAttributedString.h"
#import "TMBundleHeader.h"
#import "CodeViewDelegate.h"
#import "CodeViewControllerDelegate.h"
#import "File.h"
#import "SyntaxHighlight.h"
#import "SyntaxHighlightingPluginDelegate.h"

// SyntaxHighlight Factory
// creates immutable SyntaxHighlight objects when called by protocol,
// which operate on their own threads.
@interface SyntaxHighlightingPlugin : NSObject<PluginDelegate, SyntaxHighlightingPluginDelegate>
@property (nonatomic, readonly) id<CodeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* theme;
@property (nonatomic, strong) NSCache* cache;
@end
