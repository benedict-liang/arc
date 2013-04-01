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
@interface SyntaxHighlight : NSObject <CodeViewMiddleware>
@property NSArray* patterns;
@property NSString* content;
@property NSDictionary* theme;
@property ArcAttributedString* output;
@property id<CodeViewControllerProtocol> delegate;
@end
