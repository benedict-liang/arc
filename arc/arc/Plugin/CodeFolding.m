//
//  CodeFolding.m
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeFolding.h"

@implementation CodeFolding
+ (void)foldsWithStart:(NSString*)foldStart
                   end:(NSString*)foldEnd
            skipRanges:(NSArray*)skips
            foldRanges:(NSArray*)foldRanges
            foldStarts:(NSArray*)foldStarts
              foldEnds:(NSArray*)foldEnds
               content:(NSString*)content
{
    NSArray* splitContent = [content componentsSeparatedByString:@"\n"];
    int curI = 0;
    NSMutableArray* stack = [NSMutableArray array];
    NSRange startRange;
    NSRange endRange;
    int offset = 0;
    while (curI < splitContent.count) {
        NSString* lineContent = [splitContent objectAtIndex:curI];
        
        startRange = [CodeFolding findFirstPattern:foldStart range:NSMakeRange(0, lineContent.length) content:lineContent];
        endRange = [CodeFolding findFirstPattern:foldEnd range:NSMakeRange(0, lineContent.length) content:lineContent];
        curI++;
        
        BOOL skipStart = [Utils range:NSMakeRange(startRange.location+offset, startRange.length) isSubsetOfRangeInArray:skips];
        BOOL skipEnd = [Utils range:NSMakeRange(endRange.location+offset, endRange.length) isSubsetOfRangeInArray:skips];
        if (startRange.location == NSNotFound && endRange.location == NSNotFound) {
            
        } else if (endRange.location == NSNotFound && !skipStart) {
            //NSLog(@"begin... %d",startRange.location+offset);
            [stack addObject:[NSNumber numberWithInt:startRange.location+offset+startRange.length]];
            foldStarts = [CodeFolding addFoldRange:NSMakeRange(startRange.location+offset, startRange.length) toArray:foldStarts forContent:content];
        } else if (startRange.location == NSNotFound && !skipEnd) {
            
            if (stack.count > 0) {
                //  NSLog(@"end %d",endRange.location+offset);
                int s = [(NSNumber*)[stack lastObject] intValue];
                [stack removeLastObject];
                NSRange r =NSMakeRange(s, endRange.location+offset - s);
                foldRanges = [CodeFolding addFoldRange:r toArray:foldRanges forContent:content];
                foldEnds = [CodeFolding addFoldRange:NSMakeRange(endRange.location+offset, endRange.length) toArray:foldEnds forContent:content];
            }
            
            
        } else {
            if (startRange.location > endRange.location && !skipEnd) {
                if (stack.count > 0) {
                    //    NSLog(@"end %d",endRange.location+offset);
                    int s = [(NSNumber*)[stack lastObject] intValue];
                    [stack removeLastObject];
                    NSRange r =NSMakeRange(s, endRange.location+offset - s);
                    foldRanges = [CodeFolding addFoldRange:r toArray:foldRanges forContent:content];
                    foldEnds = [CodeFolding addFoldRange:NSMakeRange(endRange.location+offset, endRange.length) toArray:foldEnds forContent:content];
                }
                
            }
        }
        offset += lineContent.length+1;
    }
    
}
+ (NSRange)findFirstPattern:(NSString*)pattern
                      range:(NSRange)range
                    content:(NSString*)content
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    
    if ((range.location + range.length <= [content length]) &&
        (range.length > 0) &&
        (range.length <= [content length]))
    {
        //NSLog(@"findFirstPattern:   %d %d",r.location,r.length);
        return [regex rangeOfFirstMatchInString:content
                                        options:0
                                          range:range];
    } else {
        //NSLog(@"index out of bounds in regex. findFirstPatten:%d %d",r.location,r.length);
        return NSMakeRange(NSNotFound, 0);
    }
    
}

+ (NSArray*)addFoldRange:(NSRange)range toArray:(NSArray*)arr forContent:(NSString*)content{
    if (range.location + range.length < content.length) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:arr];
        [temp addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
        return temp;
    } else {
        NSLog(@"fold range out of bounds");
        return arr;
    }
    
}
@end
