//
//  FullTextSearch.m
//  arc
//
//  Created by Benedict Liang on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FullTextSearch.h"

@implementation FullTextSearch

+ (NSArray*)searchForText:(NSString*)searchText inFile:(id<File>)file {
    if (![[file contents] isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *fileString = (NSString*)[file contents];
    
    NSMutableArray *rangesArray = [[NSMutableArray alloc] init];
    
    int length = [fileString length];
    NSRange range = NSMakeRange(0, length);
    
    while(range.location != NSNotFound)
    {
        range = [fileString rangeOfString:searchText
                                  options:NSCaseInsensitiveSearch
                                    range:range];
        
        [rangesArray addObject:[NSValue valueWithRange:range]];
        
        if(range.location != NSNotFound) {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
        }
    }
    
    if ([rangesArray count] == 1) {
        return nil;
    }
    
    [rangesArray removeLastObject];
    
    return [NSArray arrayWithArray:rangesArray];
}

@end
