//
//  SyntaxHighlight.m
//  arc
//
//  Created by omer iqbal on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxHighlight.h"
#import "ArcAttributedString.h"

@implementation SyntaxHighlight
+ (void)arcAttributedString:(ArcAttributedString *)arcAttributedString OfFile:(id<File>)file delegate:(id)del

{
    SyntaxHighlight *sh = [[self alloc] initWithFile:file del:del];
    ArcAttributedString *copy = [[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString];
    [sh performSelectorInBackground:@selector(execOn:) withObject:copy];
}
- initWithFile:(id<File>)file del:(id)d {
    self = [super init];
    if (self) {
        _delegate = d;
        _currentFile = file;
        _content = [file contents];
        _patterns = [TMBundleSyntaxParser getPatternsArray:@"javascript.tmbundle"];
        _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
    }
    return self;
}

- (NSArray*)foundPattern:(NSString*)p range:(NSRange)r {
  
    return [self foundPattern:p capture:0 range:r];
}

- (NSRange)findFirstPattern:(NSString*)p range:(NSRange)r {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:0
                                  error:&error];
    
    if ((r.location + r.length <= [_content length]) && (r.length > 0) && (r.length <= [_content length])) {
        //NSLog(@"findFirstPattern:   %d %d",r.location,r.length);
        return [regex rangeOfFirstMatchInString:_content options:0 range:r];
    } else {
        NSLog(@"index out of bounds in regex. findFirstPatten:%d %d",r.location,r.length);
        return NSMakeRange(NSNotFound, 0);
    }
    
}
- (NSArray*)foundPattern:(NSString*)p capture:(int)c range:(NSRange)r {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:0
                                  error:&error];
    
    
    
    if (r.location + r.length <= [_content length]) {
        NSArray* matches = [regex matchesInString:_content options:0 range:r];
        for (NSTextCheckingResult *match in matches) {
            NSRange range = [match rangeAtIndex:c];
            if (range.location != NSNotFound) {
                [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
            }
        
        }
    } else {
        NSLog(@"index error in capture:%d %d",r.location,r.length);
    }
    
    return results;
}
- (void)styleOnRange:(NSRange)range fcolor:(UIColor*)fcolor output:(ArcAttributedString*)output {
    [output setColor:[fcolor CGColor] OnRange:range];
}

- (NSArray*)capturableScopes:(NSString*)name {
    NSArray *splitScopes = [name componentsSeparatedByString:@"."];
    NSString *accum = nil;
    NSMutableArray *scopes = [NSMutableArray array];
    
    for (NSString*  s in splitScopes) {
        if (!accum) {
            accum = s;
        } else {
            accum = [accum stringByAppendingFormat:@".%@",s];
        }
        [scopes addObject:accum];
    }
    return scopes;
}

- (void)applyStyleToScope:(NSString*)name range:(NSRange)range output:(ArcAttributedString*)o {
    
    NSArray* capturableScopes = [self capturableScopes:name];
    for (NSString *s in capturableScopes) {
        NSDictionary* style = [(NSDictionary*)[_theme objectForKey:@"scopes"] objectForKey:s];
        UIColor *fg = nil;
        if (style) {
            fg = [style objectForKey:@"foreground"];
        }
        if (fg) {
            [self styleOnRange:range fcolor:fg output:o];
        }
    }
}

- (NSDictionary*)findCaptures:(NSArray*)captures pattern:(NSString*)match range:(NSRange)r {

    // Original Code
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    NSArray *captureMatches = nil;
//    for (int i = 0; i < [captures count]; i++) {
//        captureMatches = [self foundPattern:match capture:i range:r];
//        [dict setObject:captureMatches forKey:[captures objectAtIndex:i]];
//    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_semaphore_t array_sema = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_apply([captures count], queue, ^(size_t i){
        dispatch_group_async(group, queue, ^ {
            NSArray *patternMatches = [self foundPattern:match capture:i range:r];
            dispatch_semaphore_wait(array_sema, DISPATCH_TIME_FOREVER);
            
            [dict setObject:patternMatches forKey:[captures objectAtIndex:i]];
            
            dispatch_semaphore_signal(array_sema);
        });
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    
    /*
    // Multithreaded
    NSMutableDictionary *aggregateDictionary = [[NSMutableDictionary alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_semaphore_t array_sema = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();

    dispatch_apply([captures count], queue, ^(size_t i){
        dispatch_group_async(group, queue, ^ {
            NSArray *captureMatches = [self foundPattern:match capture:i range:r];
            for (NSValue *v in captureMatches) {
                
            }
            dispatch_semaphore_wait(array_sema, DISPATCH_TIME_FOREVER);
            //[aggregateDictionary setObject:[NSNumber numberWithInt:(int)i] forKey:patternArray];
            dispatch_semaphore_signal(array_sema);
       });
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    
    for (NSArray *arr in [aggregateDictionary allKeys]) {
        NSNumber *index = (NSNumber*)[aggregateDictionary objectForKey:arr];
        for (NSValue *v in arr) {
            NSRange range;
            [v getValue:&range];
            [self applyStyleToScope:[captures objectAtIndex:[index integerValue]] range:range output:o];
        }
    }
    // Multithreaded ends here*/
    return dict;
}
-(void)applyStylesTo:(ArcAttributedString*)output withRanges:(NSDictionary*)pairs {
    if (pairs) {
        for (NSString* scope in pairs) {
            NSArray* ranges = [pairs objectForKey:scope];
            for (NSValue *v in ranges) {
                NSRange range;
                [v getValue:&range];
                [self applyStyleToScope:scope range:range output:output];
            }
        }
    }
    
}
-(NSDictionary*)merge:(NSDictionary*)d1 withd2:(NSDictionary*)d2 {
    NSMutableDictionary* res = [[NSMutableDictionary alloc] initWithDictionary:d1];
    
    for (id k in d2) {
        [res setValue:[d2 objectForKey:k] forKey:k];
    }
    return res;
}
-(void)iterPatternsForRange:(NSRange)contentRange patterns:(NSArray*)patterns output:(ArcAttributedString*)output {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_semaphore_t outputSema = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();

    
    dispatch_apply([patterns count], queue, ^(size_t i){
        dispatch_group_async(group, queue, ^{
            NSDictionary* syntaxItem = [patterns objectAtIndex:i];
            NSString *name = [syntaxItem objectForKey:@"name"];
            NSString *match = [syntaxItem objectForKey:@"match"];
            NSString *begin = [syntaxItem objectForKey:@"begin"];
            NSArray *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
            NSString *end = [syntaxItem objectForKey:@"end"];
            NSArray *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
            NSArray *captures = [syntaxItem objectForKey:@"captures"];
            

            
            //case name, match
            if (name && match) {
                NSArray *a = [self foundPattern:match range:contentRange];
                nameMatches = [self merge:@{name: a} withd2:nameMatches];
            }
            if (captures && match) {
                captureMatches = [self merge:[self findCaptures:captures pattern:match range:contentRange] withd2:captureMatches];
            }
            if (beginCaptures && begin) {
                beginCMatches = [self merge:[self findCaptures:beginCaptures pattern:begin range:contentRange] withd2:beginCMatches];
            }
            if (endCaptures && end) {
                endCMatches = [self merge:[self findCaptures:endCaptures pattern:end range:contentRange] withd2:endCMatches];
            }
            
            //matching blocks
            
            if (begin && end)
            {
                /*
                 Algo finds a begin match and an end match (from begin to content's end), reseting the next begin to after end, until no more matches are found or end > content
                 Also applies nested patterns recursively
                 
                 TODO. debug for why single line comments aren't working
                 Symptoms: comment.single.* for js tmbundle is inside a begin end pair, of which begin - end = 1.
                 
                 if ([begin isEqualToString:@"(^[ \\t]+)?(?=//)"] && [end isEqualToString:@"(?!\\G)"]) {
                     NSLog(@"finally");
                     
                      NSRange brange = [self findFirstPattern:begin range:contentRange];
                     NSLog(@"%d %d", brange.location, brange.length);
                     long bEnds = brange.location + brange.length;
                     //NSRange erange = [self findFirstPattern:end range:NSMakeRange(bEnds, contentRange.length - bEnds - 1)];
                     //NSRange erange = NSMakeRange(bEnds, );
                    // NSLog(@"%d %d", erange.location, erange.length);
                     
                }*/
                //NSLog(@"before brange: %d %d", contentRange.location, contentRange.length);
                NSRange brange = [self findFirstPattern:begin range:contentRange];
                NSRange erange = NSMakeRange(0, 0);
                
                while (brange.location != NSNotFound && erange.location + erange.length < contentRange.length ) {
                    
                    // using longs because int went out of range as NSNotFound returns MAX_INT, which fucks arithmetic
                    long bEnds = brange.location + brange.length;
                    if (contentRange.length > bEnds) {
                        //NSLog(@"before erange: %d %d", bEnds, contentRange.length - bEnds);

                        //HACK BELOW. BLAME TEXTMATE FOR THIS SHIT. IT MAKES COMMENTS WORK THOUGH
                        if ([self fixAnchor:end]) {
                            erange = NSMakeRange(bEnds, contentRange.length - bEnds);
                        } else {
                            erange = [self findFirstPattern:end range:NSMakeRange(bEnds, contentRange.length - bEnds - 1)];

                        }
                    } else {
                        //if bEnds > contentRange.length, skip
                        break;
                    }
                    
                    long eEnds = erange.location + erange.length;
                    NSArray *embedPatterns = [syntaxItem objectForKey:@"patterns"];
                    //if there are characters between begin and end, and brange and erange are valid results
                    if (eEnds - brange.location > 0 && brange.location != NSNotFound && erange.location != NSNotFound && eEnds <= contentRange.length) {
                        if (embedPatterns) {
                            //recursively apply iterPatterns to embedded patterns inclusive of begin and end
                            [self iterPatternsForRange:NSMakeRange(brange.location, eEnds - brange.location) patterns:embedPatterns output:output];
                        }
                        
                        if (name) {
                            
                           dispatch_semaphore_wait(outputSema, DISPATCH_TIME_FOREVER);
                           // NSLog(@"%@",name);
                            [self applyStyleToScope:name range:NSMakeRange(brange.location, eEnds - brange.location) output:output];
                            dispatch_semaphore_signal(outputSema);
                        }
                        //NSLog(@"before brange2: %d %d", contentRange.location, contentRange.length);
                        brange = [self findFirstPattern:begin range:NSMakeRange(eEnds, contentRange.length - eEnds)];
                    }
                    
                }
                
            }

        });
    });


    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    dispatch_release(group);

}

- (BOOL)fixAnchor:(NSString*)pattern {
    //return [pattern stringByReplacingOccurrencesOfString:@"\\G" withString:@"\uFFFF"];
    // TODO: pattern for \\z : @"$(?!\n)(?<!\n)"
    return ([pattern rangeOfString:@"\\G"].location != NSNotFound ||
            [pattern rangeOfString:@"\\A"].location != NSNotFound);
}

- (void)updateView {
    if (self.delegate) {
        [self.delegate mergeAndRenderWith:_finalOutput forFile:self.currentFile];
    }
}
- (void)execOn:(ArcAttributedString *)arcAttributedString {
    _finalOutput = arcAttributedString;
    ArcAttributedString* output = arcAttributedString;
    [self iterPatternsForRange:NSMakeRange(0, [_content length]) patterns:_patterns output:arcAttributedString];
    [self applyStylesTo:output withRanges:nameMatches];
    [self applyStylesTo:output withRanges:captureMatches];
    [self applyStylesTo:output withRanges:beginCMatches];
    [self applyStylesTo:output withRanges:endCMatches];
    [self updateView];
 
}
@end
