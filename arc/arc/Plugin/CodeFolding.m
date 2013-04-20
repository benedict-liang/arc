
//
//  CodeFolding.m
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeFolding.h"

@implementation CodeFolding

+ (FoldTree *)foldTreeForContent:(NSString *)content
                       foldStart:(NSString *)foldStart
                         foldEnd:(NSString *)foldEnd
                      skipRanges:(NSArray *)skips
                        delegate:(id<SyntaxHighlightDelegate>)del
{
    NSDictionary* foldResults = [CodeFolding foldsWithStart:foldStart
                                                        end:foldEnd
                                                 skipRanges:skips
                                                    content:content];
    
    if (foldResults) {
        NSArray *foldStarts = [foldResults objectForKey:@"foldStarts"];
        NSArray *foldEnds = [foldResults objectForKey:@"foldEnds"];
        NSArray *foldRanges = [foldResults  objectForKey:@"foldRanges"];
        
        NSArray *nodeArray = [CodeFolding nodeArrayWithFoldRanges:foldRanges
                                                       foldStarts:foldStarts
                                                         foldEnds:foldEnds];

        FoldTree *tree = [[FoldTree alloc] initWithNodes:nodeArray
                                               RootRange:NSMakeRange(0, content.length)];
        return tree;
    }

    return nil;
}
+ (NSDictionary*)foldsWithStart:(NSString*)foldStart
                            end:(NSString*)foldEnd
                     skipRanges:(NSArray*)skips
                        content:(NSString*)content
{
    NSArray* foldRanges;
    NSArray* foldStarts;
    NSArray* foldEnds;
    
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
            [stack addObject:[Utils valueFromRange:NSMakeRange(startRange.location+offset, startRange.length)]];
            //[stack addObject:[NSNumber numberWithInt:startRange.location+offset+startRange.length]];
            //foldStarts = [CodeFolding addFoldRange:NSMakeRange(startRange.location+offset, startRange.length) toArray:foldStarts forContent:content];
        } else if (startRange.location == NSNotFound && !skipEnd) {
            
            if (stack.count > 0) {
                //  NSLog(@"end %d",endRange.location+offset);
                //int s = [(NSNumber*)[stack lastObject] intValue];
                NSRange poppedStartRange = [Utils rangeFromValue:(NSValue*)[stack lastObject]];
                [stack removeLastObject];
                int sEnds = poppedStartRange.location+poppedStartRange.length;
                NSRange r =NSMakeRange(sEnds, endRange.location+offset - sEnds);
                foldStarts = [CodeFolding addFoldRange:poppedStartRange toArray:foldStarts forContent:content];
                foldRanges = [CodeFolding addFoldRange:r toArray:foldRanges forContent:content];
                foldEnds = [CodeFolding addFoldRange:NSMakeRange(endRange.location+offset, endRange.length) toArray:foldEnds forContent:content];
            }
        } else {
            if (startRange.location > endRange.location && !skipEnd) {
                if (stack.count > 0) {
                    NSRange poppedStartRange = [Utils rangeFromValue:(NSValue*)[stack lastObject]];
                    [stack removeLastObject];
                    int sEnds = poppedStartRange.location+poppedStartRange.length;
                    NSRange r =NSMakeRange(sEnds, endRange.location+offset - sEnds);
                    foldStarts = [CodeFolding addFoldRange:poppedStartRange toArray:foldStarts forContent:content];
                    foldRanges = [CodeFolding addFoldRange:r toArray:foldRanges forContent:content];
                    foldEnds = [CodeFolding addFoldRange:NSMakeRange(endRange.location+offset, endRange.length) toArray:foldEnds forContent:content];

                }
            }
        }
        offset += lineContent.length+1;
    }

    if (foldRanges && foldStarts && foldEnds) {
        return @{
                 @"foldRanges":foldRanges,
                 @"foldStarts":foldStarts,
                 @"foldEnds":foldEnds
                 };
    }
    return nil;
}

+ (NSRange)findFirstPattern:(NSString *)pattern
                      range:(NSRange)range
                    content:(NSString *)content
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

+ (NSArray *)addFoldRange:(NSRange)range
                  toArray:(NSArray *)array
               forContent:(NSString *)content
{
    if (range.location + range.length < content.length) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:array];
        [temp addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
        return temp;
    } else {
        NSLog(@"fold range out of bounds");
        return array;
    }
    
}

+ (NSArray *)nodeArrayWithFoldRanges:(NSArray *)foldRanges
                          foldStarts:(NSArray *)foldStarts
                            foldEnds:(NSArray *)foldEnds
{
    NSMutableArray* accum = [NSMutableArray array];
    for (int i = 0; i < foldRanges.count; i++) {
        FoldNode* node = [[FoldNode alloc] initWithContentRange:[Utils rangeFromValue:[foldRanges objectAtIndex:i]]
                                                     startRange:[Utils rangeFromValue:[foldStarts objectAtIndex:i]]
                                                       endRange:[Utils rangeFromValue:[foldEnds objectAtIndex:i]]];
        [accum addObject:node];
    }
    return accum;
}

@end
