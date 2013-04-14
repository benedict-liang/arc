//
//  SyntaxHighlightingPluginDelegate.h
//  arc
//
//  Created by Yong Michael on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SyntaxHighlight;

@protocol SyntaxHighlightingPluginDelegate <NSObject>
- (void)removeFromThreadPool:(SyntaxHighlight *)sh;
@end
