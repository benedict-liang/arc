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

// a SyntaxHighlight factory of sorts. creates immutable SyntaxHighlight objects when called by protocol, which operate on their own threads.

@interface SyntaxHighlightingPlugin : NSObject<PluginDelegate> {
 
}

@property (readonly) id<CodeViewControllerDelegate> delegate;
@property NSMutableDictionary* cache;
@end
