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
#import "CodeViewDelegate.h"
#import "File.h"
@interface SyntaxHighlight : NSObject <CodeViewMiddleware> {
    __block NSDictionary *nameMatches;
    __block NSDictionary *captureMatches;
    __block NSDictionary *beginCMatches;
    __block NSDictionary *endCMatches;
    __block NSDictionary *pairMatches;
}
@property NSDictionary* theme;
@property (readonly) id<CodeViewDelegate> delegate;
@property (readonly) id<File> currentFile;
@property (readonly) NSString* content;
@property (readonly) NSArray* patterns;
@property ArcAttributedString* finalOutput;
@end
