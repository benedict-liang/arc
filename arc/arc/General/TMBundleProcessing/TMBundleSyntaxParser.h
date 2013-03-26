//
//  TMBundleSyntaxParser.h
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBundleSyntaxParser : NSObject

- (NSArray*)getFileTypes:(NSString*)TMBundleName;
- (NSArray*)getFoldingMarkers:(NSString*)TMBundleName;
- (NSArray*)getFirstLineMatch:(NSString*)TMBundleName;

@end
