//
//  SyntaxHighlight.h
//  arc
//
//  Created by omer iqbal on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CodeViewMiddleware.h"
#import "ArcAttributedString.h"
#import "TMBundleHeader.h"
#import "CodeViewControllerProtocol.h"
#import "File.h"
@interface SyntaxHighlight : NSObject <CodeViewMiddleware>
@property NSDictionary* theme;
@property (readonly) ArcAttributedString* output;
@property (readonly) id<CodeViewControllerProtocol> delegate;
@property (readonly) id<File> currentFile;
@property (readonly) NSString* content;
@property (readonly) NSArray* patterns;
@end
