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
    
    if (sh.bundle) {
    
        ArcAttributedString *copy = [[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString];
        
        [sh performSelectorInBackground:@selector(execOn:) withObject:copy];
    }
}

- initWithFile:(id<File>)file del:(id)d {
    self = [super init];
    if (self) {
        _delegate = d;
        
        _currentFile = file;
        
        _bundle = [TMBundleSyntaxParser plistForExt:[file extension]];
        
        _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
        
        if ([[file contents] isKindOfClass:[NSString class]]) {
            _content = (NSString*)[file contents];
        }
        else {
            self = nil;
        }
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
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines | NSRegularExpressionAllowCommentsAndWhitespace
                                  error:&error];
    
    if ((r.location + r.length <= [_content length]) && (r.length > 0) && (r.length <= [_content length])) {
        //NSLog(@"findFirstPattern:   %d %d",r.location,r.length);
        return [regex rangeOfFirstMatchInString:_content options:0 range:r];
    } else {
        //NSLog(@"index out of bounds in regex. findFirstPatten:%d %d",r.location,r.length);
        return NSMakeRange(NSNotFound, 0);
    }
    
}
- (NSArray*)foundPattern:(NSString*)p capture:(int)c range:(NSRange)r {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines | NSRegularExpressionAllowCommentsAndWhitespace
                                  error:&error];
    
    
    
    if (r.location + r.length <= [_content length]) {
        @try {
            NSArray* matches = [regex matchesInString:_content options:0 range:r];
            for (NSTextCheckingResult *match in matches) {
                @try {
                    NSRange range = [match rangeAtIndex:c];
                    if (range.location != NSNotFound) {
                        [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"exception at found pattern. results:%@ \n matches:%@",results, match);
                    return results;
                }
                @finally {
                    
                }
            }

        }
        @catch (NSException *exception) {
            NSLog(@"Exception in matches");
        }
        @finally {
            
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

- (NSDictionary*)findCaptures:(NSDictionary*)captures pattern:(NSString*)match range:(NSRange)r {

    // Original Code
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSArray *captureM = nil;
    for (id k in captures) {
        int i = [k intValue];
        captureM = [self foundPattern:match capture:i range:r];
        [dict setObject:captureM forKey:k];
    }
//    for (int i = 0; i < [captures count]; i++) {
//        captureM = [self foundPattern:match capture:i range:r];
//        [captures objectForKey:]
//        [dict setObject:captureM forKey:[captures objectForKey:[NSString stringWithFormat:@"%d",i]]];
//    }
    
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_semaphore_t array_sema = dispatch_semaphore_create(1);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_apply([captures count], queue, ^(size_t i){
//        dispatch_group_async(group, queue, ^ {
//            NSArray *patternMatches = [self foundPattern:match capture:i range:r];
//            dispatch_semaphore_wait(array_sema, DISPATCH_TIME_FOREVER);
//            
//            [dict setObject:patternMatches forKey:[captures objectAtIndex:i]];
//            
//            dispatch_semaphore_signal(array_sema);
//        });
//    });
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    dispatch_release(group);
//    

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
- (NSDictionary*) addRange:(NSRange)r scope:(NSString*)s dict:(NSDictionary*)d {
 
    
    NSMutableDictionary* res = [NSMutableDictionary dictionaryWithDictionary:d];
    NSArray* ranges = [res objectForKey:s];
    if (ranges) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:ranges];
        
        [temp addObject:[NSValue value:&r withObjCType:@encode(NSRange)]];
        [res setObject:temp forKey:s];
    } else {
        
        [res setObject:@[[NSValue value:&r withObjCType:@encode(NSRange)]] forKey:s];
        
    }
    return res;
}
- (id)repositoryRule:(NSString*)rule {
    NSDictionary* repo = [_bundle objectForKey:@"repository"];
    return [repo objectForKey:rule];
}
- (NSArray*)externalInclude:(NSString*)name {
    
    NSDictionary *includedBundle = [TMBundleSyntaxParser plistByName:name];
    return [includedBundle objectForKey:@"patterns"];
}
- (NSArray*)resolveInclude:(NSString*)include {
    
    if ([include isEqualToString:@"$self"]) {
        //returns top most pattern
        return [_bundle objectForKey:@"patterns"];
    }
    else if ([include characterAtIndex:0] == '#') {
        // Get rule from repository
        NSString *str = [include substringFromIndex:1];
        id rule = [self repositoryRule:str];
        if (rule) {
            return [NSArray arrayWithObject:rule];
        } else {
            return nil;
        }
        
    }
    else {
        //TODO: find scope name of another language
        return [self externalInclude:include];
    }

}

-(void)iterPatternsForRange:(NSRange)contentRange patterns:(NSArray*)patterns output:(ArcAttributedString*)output {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();

    
    dispatch_apply([patterns count], queue, ^(size_t i){
        dispatch_group_async(group, queue, ^{
            NSDictionary* syntaxItem = [patterns objectAtIndex:i];
            NSString *name = [syntaxItem objectForKey:@"name"];
            NSString *match = [syntaxItem objectForKey:@"match"];
            NSString *begin = [syntaxItem objectForKey:@"begin"];
            NSDictionary *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
            NSString *end = [syntaxItem objectForKey:@"end"];
            NSDictionary *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
            NSDictionary *captures = [syntaxItem objectForKey:@"captures"];
            NSString *include = [syntaxItem objectForKey:@"include"];
 
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
               */
 
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

                            pairMatches = [self addRange:NSMakeRange(brange.location, eEnds - brange.location) scope:name dict:pairMatches];

                        }
                        brange = [self findFirstPattern:begin range:NSMakeRange(eEnds, contentRange.length - eEnds)];
                    }
                    
                }
                
            }
            if (include) {
                id includes = [self resolveInclude:include];
                [self iterPatternsForRange:contentRange patterns:includes output:output];
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
- (void)logs {
    NSLog(@"%@",nameMatches);
    NSLog(@"%@",captureMatches);
    NSLog(@"%@",beginCMatches);
    NSLog(@"%@",endCMatches);
    NSLog(@"%@",pairMatches);
    
}
- (void)execOn:(ArcAttributedString *)arcAttributedString {
    _finalOutput = arcAttributedString;
    ArcAttributedString* output = arcAttributedString;
    [self iterPatternsForRange:NSMakeRange(0, [_content length]) patterns:[_bundle objectForKey:@"patterns"] output:arcAttributedString];

    [self applyStylesTo:output withRanges:nameMatches];
    [self applyStylesTo:output withRanges:captureMatches];
    [self applyStylesTo:output withRanges:beginCMatches];
    [self applyStylesTo:output withRanges:endCMatches];
    [self applyStylesTo:output withRanges:pairMatches];
    [self logs];
    [self updateView];
 
}
@end
