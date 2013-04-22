//
//  SyntaxHighlight.m
//  arc
//
//  Created by omer iqbal on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxHighlight.h"
#define SYNTAX_KEY @"sh"

@interface SyntaxHighlight ()
@property (nonatomic) BOOL isAlive;
@property (nonatomic) BOOL matchesDone;
@property SyntaxMatchStore* matchStore;
@property SyntaxMatchStore* overlapStore;
@end

@implementation SyntaxHighlight
@synthesize factory = _factory;
@synthesize delegate = _delegate;

- (id)initWithFile:(id<File>)file andDelegate:(id<CodeViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _currentFile = file;
        _overlays = @[@"string",@"comment"];
        _bundle = [TMBundleSyntaxParser plistForExt:[file extension]];
        
        _syntaxPatterns = [[SyntaxPatterns alloc] initWithBundlePatterns:[_bundle objectForKey:@"patterns"] Repository:[_bundle objectForKey:@"repository"]];
        //NSLog(@"%@",_syntaxPatterns);
        _isAlive = YES;
        _matchesDone = NO;
        
        if ([[file contents] isKindOfClass:[NSString class]]) {
            _content = (NSString*)[file contents];
            _splitContent = [_content componentsSeparatedByString:@"\n"];
        }
        _overlapStore = [[SyntaxMatchStore alloc] init];
        //reset ranges
        
    }
    return self;
}

- (void)styleOnRange:(NSRange)range
              fcolor:(UIColor*)fcolor
              output:(ArcAttributedString*)output
{

}

- (NSArray*)capturableScopes:(NSString*)name
{
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

- (void)applyStyleToScope:(NSString*)name
                    range:(NSRange)range
                   output:(ArcAttributedString*)output
                     dict:(NSObject*)dict
                    theme:(NSDictionary*)theme
               capturableScopes:(NSArray*)cpS
{
    NSDictionary* global = [theme objectForKey:@"global"];
    UIColor* foreground = [global objectForKey:@"foreground"];
    NSDictionary* style = nil;
    NSString* fscope = nil;
    NSDictionary* styleScopes = [theme objectForKey:@"scopes"];
    for (NSString *s in cpS) {
        NSDictionary* scopeStyle = [styleScopes objectForKey:s];
        if (scopeStyle) {
            style = scopeStyle;
            fscope = s;
        }
        
    }
    if (style) {
        NSLog(@"%@  scope:%@",style,fscope);
        UIColor *fg = [style objectForKey:@"foreground"];
        
        if (!fg) {
            return;
        }
        //NSLog(@"s = %@ \n fg = %@",s,fg);
        [output setForegroundColor:fg
                           OnRange:range
                        ForSetting:SYNTAX_KEY];
    }
}



- (void)applyStylesTo:(ArcAttributedString*)output
           withRanges:(SyntaxMatchStore*)pairs
            withTheme:(NSDictionary*)theme
{
    if (pairs) {
        for (NSString* scope in pairs.scopes) {
            NSLog(@"%@",pairs.scopes);
            NSArray* ranges = [pairs rangesForScope:scope];
            NSArray* capturableScopes = [pairs capturableScopesForScope:scope];
            if (!capturableScopes) {
                capturableScopes = [self capturableScopes:scope];
            }
            if ([capturableScopes[0] isEqualToString:@"comment"] && ![pairs isEqual:_overlapStore]) {
                [_overlapStore addParserResult:[[SyntaxParserResult alloc] initWithScope:scope Ranges:ranges CPS:capturableScopes]];
                continue;
            }
//            if ([[capturableScopes objectAtIndex:0] isEqualToString:@"meta"]) {
//                NSLog(@"arrgh");
//            }
            
            NSDictionary* styleScopes = [theme objectForKey:@"scopes"];
            NSLog(@"%@",capturableScopes);
            NSLog(@"%@",styleScopes);
            UIColor* fg = nil;
            for (NSString* ascope in capturableScopes) {
                NSDictionary* style = [styleScopes objectForKey:ascope];
                if (style) {
                    fg = [style objectForKey:@"foreground"];
                }
            }
            if (fg) {
                for (NSValue *v in ranges) {
                    
                    NSRange range = [Utils rangeFromValue:v];
                    [output setForegroundColor:fg
                                       OnRange:range
                                    ForSetting:SYNTAX_KEY];
                }
            }
        
        }
    }
    
}


//
//- (NSArray*)resolveInclude:(NSString*)include
//{
//    //NSLog(@"%@",include);
//    if ([include isEqualToString:@"$base"]) {
//        //returns top most pattern
//        return [_bundle objectForKey:@"patterns"];
//    } else if ([include characterAtIndex:0] == '#') {
//        // Get rule from repository
//        NSString *str = [include substringFromIndex:1];
//        
//        if ([str isEqualToString:@"comment"]) {
//            NSLog(@"%@", [self repositoryRule:str]);
//        }
//        
//        id rule = [self repositoryRule:str];
//        
//        if (rule) {
//            return [NSArray arrayWithObject:rule];
//        } else {
//            return nil;
//        }
//    } else {
//        //TODO: find scope name of another language
//        return [self externalInclude:include];
//    }
//    
//}
- (BOOL)isEscapedOnRange:(NSRange)range {
    if ([Utils isContainedByRange:NSMakeRange(0, _content.length) Index:range.location-1]) {
        unichar c =  [_content characterAtIndex:range.location-1];
        return c=='\\';
    }
    return NO;
}



//- (OverlapPeekResult*)peekMinForItems:(NSArray*)syntaxItems WithRange:(NSRange)range {
//    NSRange minBegin = NSMakeRange(_content.length, 0);
//    NSRange minEnd = minBegin;
//    //NSRange minMatch = minBegin;
//    NSDictionary* minSyntax = nil;
//    SyntaxType minType = kNone;
//    for (NSDictionary* syntaxItem  in syntaxItems) {
//        NSString* match = [syntaxItem objectForKey:@"match"];
//        NSString* begin = [syntaxItem objectForKey:@"begin"];
//        NSString* end = [syntaxItem objectForKey:@"end"];
//        NSArray* embedPatterns = [syntaxItem objectForKey:@"patterns"];
//        NSString* include = [syntaxItem objectForKey:@"include"];
//        if (match) {
//            NSRange matchResult = [self findFirstPattern:match range:range content:_content];
//            if (minBegin.location > matchResult.location) {
//                minType = kSyntaxSingle;
//                minBegin = matchResult;
//                minSyntax = syntaxItem;
//            }
//        }
//        else if (begin && end) {
//            NSRange bresult = [self findFirstPattern:begin range:range content:_content];
//            if (bresult.location > range.length) {
//                continue;
//            }
//            CFIndex bEnds = bresult.location+bresult.length;
//            NSRange findEndRange = NSMakeRange(bEnds, range.length - bEnds);
////            if (embedPatterns) {
////                [self handleOverlaps:embedPatterns WithinRange:findEndRange];
////                
////            }
//            
//            NSRange eresult = [self findFirstPattern:end range:findEndRange content:_content];
//            
//            if (minBegin.location > bresult.location && eresult.location < range.length && bresult.location < range.length && eresult.location > bresult.location) {
//                minType = kSyntaxPair;
//                minBegin = bresult;
//                minSyntax = syntaxItem;
//                minEnd = eresult;
//            }
//        }
////        else if (include) {
////            NSArray* includes = [self resolveInclude:include];
////            [self handleOverlaps:includes WithinRange:range];
////        }
//    }
//    if (minSyntax && minType == kSyntaxPair) {
//        return [OverlapPeekResult resultWithBeginRange:minBegin EndRange:minEnd SyntaxItem:minSyntax];
//    } else if (minSyntax && minType == kSyntaxSingle) {
//        return [OverlapPeekResult resultWithMatchRange:minBegin SyntaxItem:minSyntax];
//    }
//    return nil;
//}


//- (void)processPairRange:(NSRange)contentRange
//                    item:(NSDictionary*)syntaxItem
//                  output:(ArcAttributedString*)output
//             PairMatches:(NSMutableDictionary *)pairMatchesStore
//          ContentMatches:(NSMutableDictionary *)contentMatchesStore
//{
//    /*
//     Algo finds a begin match and an end match (from begin to content's end),
//     reseting the next begin to after end, until no more matches are found or end > content
//     Also applies nested patterns recursively
//     */
//    NSString* begin = [syntaxItem objectForKey:@"begin"];
//    NSString* end = [syntaxItem objectForKey:@"end"];
//    NSString* name = [syntaxItem objectForKey:@"name"];
//    
//    NSRegularExpression *beginRegex = [self regexForPattern:begin];
//
//    NSRegularExpression *endRegex = [self regexForPattern:end];
//    
//    NSRange brange = [self findFirstPatternWithRegex:beginRegex
//                                      range:contentRange];
//    NSArray* capturableScopes = [syntaxItem objectForKey:@"capturableScopes"];
//    
//    
//    NSRange erange;
//    do {
//        // NSLog(@"traversing while brange:%@ erange:%@",
//        // [NSValue value:&brange withObjCType:@encode(NSRange)],
//        // [NSValue value:&erange withObjCType:@encode(NSRange)]);
//        // using longs because int went out of range as NSNotFound returns MAX_INT, which fucks arithmetic
//        long bEnds = brange.location + brange.length;
//        if (contentRange.length > bEnds) {
//            //HACK BELOW. BLAME TEXTMATE FOR THIS SHIT. IT MAKES COMMENTS WORK THOUGH
//            //if ([self fixAnchor:end]) {
//            //erange = NSMakeRange(bEnds, contentRange.length - bEnds);
//            //} else {
//            erange = [self findFirstPatternWithRegex:endRegex
//                                               range:NSMakeRange(bEnds, contentRange.length - bEnds - 1)];
//            //}
//        } else {
//            //if bEnds > contentRange.length, skip
//            break;
//        }
//        
//        long eEnds = erange.location + erange.length;
//        NSArray *embedPatterns = [syntaxItem objectForKey:@"patterns"];
//        
//        //if there are characters between begin and end, and brange and erange are valid results
//        if (eEnds > brange.location &&
//            brange.location != NSNotFound &&
//            erange.location != NSNotFound &&
//            eEnds - brange.location< contentRange.length) {
//            
//            if (name) {
//                [self addRange:NSMakeRange(brange.location, eEnds - brange.location)
//                                       scope:name
//                                        dict:pairMatchesStore
//                            capturableScopes:capturableScopes];
//            }
//            
//            if ([syntaxItem objectForKey:@"contentName"]) {
//                 [self addRange:NSMakeRange(bEnds, eEnds - bEnds)
//                                              scope:name
//                                               dict:contentMatchesStore
//                                   capturableScopes:capturableScopes];
//            }
//            
//            if (embedPatterns &&
//                contentRange.length < [_content length]) {
//                //recursively apply iterPatterns to embedded patterns inclusive of begin and end
//                // [self logs];
//                // NSLog(@"recurring with %d %ld", brange.location, eEnds - brange.location);
//                [self iterPatternsForRange:NSMakeRange(brange.location, eEnds - brange.location)
//                                  patterns:embedPatterns
//                                    output:output];
//            }
//        }
//        
//        brange = [self findFirstPatternWithRegex:beginRegex
//                                           range:NSMakeRange(eEnds, contentRange.length - eEnds)];
//        
//    } while ([self whileCondition:brange e:erange cr:contentRange]);
//    
//    
//}
//- (void)iterPatternsForRange:(NSRange)contentRange
//                    patterns:(NSArray*)patterns
//                      output:(ArcAttributedString*)output
//{
//    for (int i =0; i < patterns.count; i++) {
//        
//    
//    //  NSLog(@"patterns: %@",patterns);
////    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
////    dispatch_group_t group = dispatch_group_create();
////    
////    
////    dispatch_apply([patterns count], queue, ^(size_t i){
////        dispatch_group_async(group, queue, ^{
//            if (_isAlive) {
//                NSDictionary* syntaxItem = [patterns objectAtIndex:i];
//                NSString *name = [syntaxItem objectForKey:@"name"];
//                NSString *match = [syntaxItem objectForKey:@"match"];
//                NSString *begin = [syntaxItem objectForKey:@"begin"];
//                NSDictionary *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
//                NSString *end = [syntaxItem objectForKey:@"end"];
//                NSDictionary *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
//                NSDictionary *captures = [syntaxItem objectForKey:@"captures"];
//                NSString *include = [syntaxItem objectForKey:@"include"];
//                NSArray* embedPatterns = [syntaxItem objectForKey:@"patterns"];
//                NSArray* capturableScopes = [syntaxItem objectForKey:@"capturableScopes"];
//                //case name, match
//                if ([_overlays containsObject:capturableScopes[0] ]) {
//                    [_overlapAccum addObject:syntaxItem];
//                    continue;
//                }
//
//                if (name && match) {
//                    NSArray *a = [self foundPattern:match
//                                              range:contentRange];
//                    [self merge:@{name: @{@"ranges":a, @"capturableScopes":capturableScopes}}
//                                       withDictionary:nameMatches];
//                }
//                
//                if (captures && match) {
//                    [self merge:[self findCaptures:captures
//                                                            pattern:match
//                                                              range:contentRange]
//                                          withDictionary:captureMatches];
//                }
//                
//                if (beginCaptures && begin) {
//                    [self merge:[self findCaptures:beginCaptures
//                                                           pattern:begin
//                                                             range:contentRange]
//                         withDictionary:beginCMatches];
//                }
//                
//                if (endCaptures && end) {
//                    [self merge:[self findCaptures:endCaptures
//                                                         pattern:end
//                                                           range:contentRange]
//                                       withDictionary:endCMatches];
//                }
//                
//                //matching blocks
//                if (begin && end) {
//                    [self processPairRange:contentRange
//                                      item:syntaxItem
//                                    output:output
//                               PairMatches:pairMatches
//                            ContentMatches:contentNameMatches];
//                    
//                } else if (embedPatterns) {
//                    [self iterPatternsForRange:contentRange patterns:embedPatterns output:output];
//                }
//                if (include) {
//                    NSArray* includes = [self resolveInclude:include];
//                    //NSLog(@"recurring for include: %@ with %d %d name:%@",includes, contentRange.location, contentRange.length, name);
//                    if (contentRange.length <= [_content length] &&
//                        includes) {
//                        [self iterPatternsForRange:contentRange
//                                          patterns:includes
//                                            output:output];
//                    }
//                }
//            }
////        });
////    });
////    
////    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    }
//
//}

//- (BOOL)whileCondition:(NSRange)brange e:(NSRange)erange cr:(NSRange)contentRange
//{
//    return (brange.location != NSNotFound &&
//            erange.location + erange.length < contentRange.length &&
//            erange.location > 0 &&
//            !(NSEqualRanges(brange, NSMakeRange(0, 0)) &&
//              (NSEqualRanges(erange, NSMakeRange(0, 0)))) &&
//            (erange.location < contentRange.length - 1));
//}

//- (BOOL)fixAnchor:(NSString*)pattern
//{
//    //return [pattern stringByReplacingOccurrencesOfString:@"\\G" withString:@"\uFFFF"];
//    // TODO: pattern for \\z : @"$(?!\n)(?<!\n)"
//    return ([pattern rangeOfString:@"\\G"].location != NSNotFound ||
//            [pattern rangeOfString:@"\\A"].location != NSNotFound);
//}

- (void)updateView:(ArcAttributedString*)output
         withTheme:(NSDictionary*)theme
{
    if (self.delegate) {
        [self.delegate mergeAndRenderWith:output
                                  forFile:_currentFile
                                WithStyle:[theme objectForKey:@"global"]
                                  AndTree:_foldTree];
    }
}

- (void)logs
{
//    NSLog(@"nameMatches: %@",nameMatches);
//    NSLog(@"captureM: %@",captureMatches);
//    NSLog(@"beginM: %@",beginCMatches);
//    NSLog(@"endM: %@",endCMatches);
//    NSLog(@"pairM: %@",pairMatches);
}

- (void)applyForeground:(ArcAttributedString*)output withTheme:(NSDictionary*)theme
{
    NSDictionary* global = [theme objectForKey:@"global"];
    UIColor* foreground = [global objectForKey:@"foreground"];
    if (foreground) {
        [self styleOnRange:NSMakeRange(0, [_content length])
                    fcolor:foreground
                    output:output];
    }
}

- (void)applyStylesTo:(ArcAttributedString*)output
            withTheme:(NSDictionary*)theme
{
    [output removeAttributesForSettingKey:SYNTAX_KEY];
    [self applyForeground:output withTheme:theme];
    [self applyStylesTo:output withRanges:_matchStore withTheme:theme];
    [self applyStylesTo:output withRanges:_overlapStore withTheme:theme];

}

- (void)setupFoldTree {
    NSString* foldStart = [_bundle objectForKey:@"foldingStartMarker"];
    NSString* foldEnd = [_bundle objectForKey:@"foldingStopMarker"];
    
    if (foldStart && foldEnd) {
        _foldTree = [CodeFolding foldTreeForContent:_content
                                          foldStart:foldStart
                                            foldEnd:foldEnd
                                         skipRanges:[NSArray array]
                                           delegate:self];
    }
}
- (void)execOn:(NSDictionary*)options
{
    _isAlive = YES;
    ArcAttributedString *output = [options objectForKey:@"attributedString"];
    _finalOutput = output;
    NSDictionary* theme = [options objectForKey:@"theme"];

    if (!_matchesDone) {

        _matchStore = [_syntaxPatterns parseResultsForContent:_content Range:NSMakeRange(0, _content.length)];
        NSLog(@"%@",_matchStore);
        [self setupFoldTree];
        [self applyStylesTo:output withTheme:theme];
        [self updateView:output withTheme:theme];
        NSLog(@"view updated!");
        _matchesDone = YES;
    }
    
    // tell SH factory to remove self from thread pool.
    [_factory removeFromThreadPool:self];

}

- (void)kill
{
    _isAlive = NO;
    _matchesDone = NO;
}

- (void)testFoldsOnFoldRanges:(NSArray*)fR
                   foldStarts:(NSArray*)fS
                     foldEnds:(NSArray*)fE
{
 
    for (NSValue*v in fR) {
        NSRange r;
        [v getValue:&r];
        [self styleOnRange:r fcolor:[UIColor yellowColor] output:_finalOutput];
    }
    //NSLog(@"_foldStarts: %@",_foldStarts);
    for (NSValue* v in fS) {
        NSRange r;
        [v getValue:&r];
        [self styleOnRange:r fcolor:[UIColor redColor] output:_finalOutput];
    }
    
    //NSLog(@"_foldEnds: %@",_foldEnds);
    for (NSValue*v in fE) {
        NSRange r;
        [v getValue:&r];
        [self styleOnRange:r fcolor:[UIColor greenColor] output:_finalOutput];
    }
    
}



@end
