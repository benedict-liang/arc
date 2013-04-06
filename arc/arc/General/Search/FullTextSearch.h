//
//  FullTextSearch.h
//  arc
//
//  Created by Benedict Liang on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "File.h"

@interface FullTextSearch : NSObject

// Returns an array of NSRange objects based on the search text passed
// into the method.
// Returns nil if no search results are found.
+ (NSArray*)searchForText:(NSString*)searchText inFile:(id<File>)file;

@end
