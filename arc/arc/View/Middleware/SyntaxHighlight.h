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
#import "TMBundleHeader.h"

@interface SyntaxHighlight : NSObject <CodeViewMiddleware>
@property NSArray* patterns;
@property NSString* content;
@property NSMutableAttributedString* output;
@end
