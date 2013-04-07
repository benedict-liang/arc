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
#import "CodeViewControllerDelegate.h"
#import "File.h"
#import "SyntaxHighlight.h"

@interface SyntaxHighlightingPlugin : NSObject<PluginDelegate> {
 
}

@property (readonly) id<CodeViewControllerDelegate> delegate;
@property NSDictionary* theme;
@end
