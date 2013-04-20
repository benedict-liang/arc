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
        
        _isAlive = YES;
        _matchesDone = NO;
        
        if ([[file contents] isKindOfClass:[NSString class]]) {
            _content = (NSString*)[file contents];
            _splitContent = [_content componentsSeparatedByString:@"\n"];
        }
        
        //reset ranges
        nameMatches = [NSDictionary dictionary];
        captureMatches = [NSDictionary dictionary];
        beginCMatches = [NSDictionary dictionary];
        endCMatches = [NSDictionary dictionary];
        pairMatches = [NSDictionary dictionary];
        contentNameMatches = [NSDictionary dictionary];
        overlapMatches = [NSDictionary dictionary];
    }
    return self;
}
- (NSRegularExpression *)regexForPattern:(NSString *)pattern {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    return regex;
}

- (NSArray*)foundPattern:(NSString*)pattern
                   range:(NSRange)range
{
    
    return [self foundPattern:pattern
                      capture:0
                        range:range];
}

- (NSRange)findFirstPattern:(NSRegularExpression *)regex
                      range:(NSRange)range
{   
    if ((range.location + range.length <= [_content length]) &&
        (range.length > 0) &&
        (range.length <= [_content length]))
    {
        return [regex rangeOfFirstMatchInString:_content
                                        options:0
                                          range:range];
    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}

- (NSRange)findFirstPattern:(NSString*)pattern
                      range:(NSRange)range
                    content:(NSString*)content
{
    
    NSRegularExpression *regex = [self regexForPattern:pattern];
    
    if ((range.location + range.length <= [content length]) &&
        (range.length > 0) &&
        (range.length <= [content length]))
    {
        //NSLog(@"findFirstPattern:   %d %d",r.location,r.length);
        return [regex rangeOfFirstMatchInString:content
                                        options:0
                                          range:range];
    } else {
        NSLog(@"index out of bounds in regex. findFirstPatten:%@",[Utils valueFromRange:range]);
        return NSMakeRange(NSNotFound, 0);
    }
    
}

- (NSArray*)foundPattern:(NSString*)pattern
                 capture:(int)capture
                   range:(NSRange)range
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [self regexForPattern:pattern];
    
    if (range.location + range.length <= [_content length]) {
        
        NSArray* matches = [regex matchesInString:_content
                                          options:0
                                            range:range];
        
        for (NSTextCheckingResult *match in matches) {
            if (capture < [match numberOfRanges]) {
                NSRange range = [match rangeAtIndex:capture];
                
                if (range.location != NSNotFound) {
                    NSValue* v = [NSValue value:&range
                                   withObjCType:@encode(NSRange)];
                    [results addObject:v];
                }
            }
            
        }
        
    } else {
        NSLog(@"index error in capture:%d %d", range.location, range.length);
    }
    
    return results;
}

- (void)styleOnRange:(NSRange)range
              fcolor:(UIColor*)fcolor
              output:(ArcAttributedString*)output
{
    [output setForegroundColor:fcolor
                       OnRange:range
                    ForSetting:SYNTAX_KEY];
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

  
    for (NSString *s in cpS) {
        NSDictionary* style = [(NSDictionary*)[theme objectForKey:@"scopes"] objectForKey:s];
        if (![dict isEqual:(NSObject*)overlapMatches] && [_overlays containsObject:s]) {
            overlapMatches = [self addRange:range
                                      scope:s
                                       dict:overlapMatches
                           capturableScopes:@[s]];
        }
        
        if (style) {
            UIColor *fg = [style objectForKey:@"foreground"];
            [self styleOnRange:range
                        fcolor:fg
                        output:output];
        }
    }
}

- (NSDictionary*)findCaptures:(NSDictionary*)captures
                      pattern:(NSString*)match
                        range:(NSRange)range
{
    
    // Original Code
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSArray *captureM = nil;
    for (id k in captures) {
        int i = [k intValue];
        captureM = [self foundPattern:match capture:i range:range];
        NSDictionary* capturedSyntaxItem = [captures objectForKey:k];
        NSString* scope = [capturedSyntaxItem objectForKey:@"name"];
        NSArray* capturableScopes = [capturedSyntaxItem objectForKey:@"capturableScopes"];
        NSDictionary *scopeData = @{@"ranges":captureM, @"capturableScopes":capturableScopes};
        [dict setObject:scopeData forKey:scope];
        
    }

    return dict;
}

- (void)applyStylesTo:(ArcAttributedString*)output
           withRanges:(NSDictionary*)pairs
            withTheme:(NSDictionary*)theme
{
    if (pairs) {
        for (NSString* scope in pairs) {
            NSArray* ranges = [[pairs objectForKey:scope] objectForKey:@"ranges"];
            NSArray* capturableScopes = [[pairs objectForKey:scope] objectForKey:@"capturableScopes"];
            for (NSValue *v in ranges) {
                NSRange range;
                [v getValue:&range];
                [self applyStyleToScope:scope
                                  range:range
                                 output:output
                                   dict:pairs
                                  theme:theme
                       capturableScopes:capturableScopes];
            }
        }
    }
    
}

- (NSDictionary*)merge:(NSDictionary*)dictionary1
                withd2:(NSDictionary*)dictionary2
{
    NSMutableDictionary* res =
    [[NSMutableDictionary alloc] initWithDictionary:dictionary1];
    
    for (id k in dictionary2) {
        [res setValue:[dictionary2 objectForKey:k]
               forKey:k];
    }
    
    return res;
}

- (NSDictionary*) addRange:(NSRange)range
                     scope:(NSString*)scope
                      dict:(NSDictionary*)matchesStore
          capturableScopes:(NSArray*)cpS
{
    NSMutableDictionary* res =
    [NSMutableDictionary dictionaryWithDictionary:matchesStore];
    
    NSArray* ranges = [[res objectForKey:scope] objectForKey:@"ranges"];
    if (ranges) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:ranges];
        [temp addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
        NSDictionary* vals = @{@"capturableScopes":cpS, @"ranges":temp};
        [res setObject:vals forKey:scope];
    } else {
        if (scope) {
            NSDictionary* vals = @{@"capturableScopes":cpS, @"ranges":@[[NSValue value:&range
                                                                          withObjCType:@encode(NSRange)]]};
            [res setObject:vals
                    forKey:scope];
        }
    }
    return res;
}

- (id)repositoryRule:(NSString*)rule
{
    NSDictionary* repo = [_bundle objectForKey:@"repository"];
    return [repo objectForKey:rule];
}

- (NSArray*)externalInclude:(NSString*)name
{
    NSDictionary *includedBundle = [TMBundleSyntaxParser plistByName:name];
    return [includedBundle objectForKey:@"patterns"];
}

- (NSArray*)resolveInclude:(NSString*)include
{
    //NSLog(@"%@",include);
    if ([include isEqualToString:@"$base"]) {
        //returns top most pattern
        return [_bundle objectForKey:@"patterns"];
    } else if ([include characterAtIndex:0] == '#') {
        // Get rule from repository
        NSString *str = [include substringFromIndex:1];
        
        if ([str isEqualToString:@"comment"]) {
            NSLog(@"%@", [self repositoryRule:str]);
        }
        
        id rule = [self repositoryRule:str];
        
        if (rule) {
            return [NSArray arrayWithObject:rule];
        } else {
            return nil;
        }
    } else {
        //TODO: find scope name of another language
        return [self externalInclude:include];
    }
    
}
- (void)processPairRange:(NSRange)contentRange
                    item:(NSDictionary*)syntaxItem
                  output:(ArcAttributedString*)output
{
    /*
     Algo finds a begin match and an end match (from begin to content's end),
     reseting the next begin to after end, until no more matches are found or end > content
     Also applies nested patterns recursively
     */
    NSString* begin = [syntaxItem objectForKey:@"begin"];
    NSString* end = [syntaxItem objectForKey:@"end"];
    NSString* name = [syntaxItem objectForKey:@"name"];
    
    NSError *error = NULL;
    NSRegularExpression *beginRegex = [NSRegularExpression
                                  regularExpressionWithPattern:begin
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines
                                  error:&error];

    NSRegularExpression *endRegex = [NSRegularExpression
                                  regularExpressionWithPattern:end
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines
                                  error:&error];

    
    NSRange brange = [self findFirstPattern:beginRegex
                                      range:contentRange];
    NSArray* capturableScopes = [syntaxItem objectForKey:@"capturableScopes"];
    NSRange erange;
    do {
        // NSLog(@"traversing while brange:%@ erange:%@",
        // [NSValue value:&brange withObjCType:@encode(NSRange)],
        // [NSValue value:&erange withObjCType:@encode(NSRange)]);
        // using longs because int went out of range as NSNotFound returns MAX_INT, which fucks arithmetic
        long bEnds = brange.location + brange.length;
        if (contentRange.length > bEnds) {
            //HACK BELOW. BLAME TEXTMATE FOR THIS SHIT. IT MAKES COMMENTS WORK THOUGH
            //if ([self fixAnchor:end]) {
            //erange = NSMakeRange(bEnds, contentRange.length - bEnds);
            //} else {
            erange = [self findFirstPattern:endRegex
                                      range:NSMakeRange(bEnds, contentRange.length - bEnds - 1)];
            //}
        } else {
            //if bEnds > contentRange.length, skip
            break;
        }
        
        long eEnds = erange.location + erange.length;
        NSArray *embedPatterns = [syntaxItem objectForKey:@"patterns"];
        
        //if there are characters between begin and end, and brange and erange are valid results
        if (eEnds > brange.location &&
            brange.location != NSNotFound &&
            erange.location != NSNotFound &&
            eEnds - brange.location< contentRange.length) {
            
            if (name) {
                pairMatches = [self addRange:NSMakeRange(brange.location, eEnds - brange.location)
                                       scope:name
                                        dict:pairMatches
                            capturableScopes:capturableScopes];
            }
            
            if ([syntaxItem objectForKey:@"contentName"]) {
                contentNameMatches = [self addRange:NSMakeRange(bEnds, eEnds - bEnds)
                                              scope:name
                                               dict:contentNameMatches
                                   capturableScopes:capturableScopes];
            }
            
            if (embedPatterns &&
                contentRange.length < [_content length]) {
                //recursively apply iterPatterns to embedded patterns inclusive of begin and end
                // [self logs];
                // NSLog(@"recurring with %d %ld", brange.location, eEnds - brange.location);
                [self iterPatternsForRange:NSMakeRange(brange.location, eEnds - brange.location)
                                  patterns:embedPatterns
                                    output:output];
            }
        }
        
        brange = [self findFirstPattern:beginRegex
                                  range:NSMakeRange(eEnds, contentRange.length - eEnds)];
        
    } while ([self whileCondition:brange e:erange cr:contentRange]);
    
    
}
- (void)iterPatternsForRange:(NSRange)contentRange
                    patterns:(NSArray*)patterns
                      output:(ArcAttributedString*)output
{
    //  NSLog(@"patterns: %@",patterns);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_apply([patterns count], queue, ^(size_t i){
        dispatch_group_async(group, queue, ^{
            if (_isAlive) {
                NSDictionary* syntaxItem = [patterns objectAtIndex:i];
                NSString *name = [syntaxItem objectForKey:@"name"];
                NSString *match = [syntaxItem objectForKey:@"match"];
                NSString *begin = [syntaxItem objectForKey:@"begin"];
                NSDictionary *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
                NSString *end = [syntaxItem objectForKey:@"end"];
                NSDictionary *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
                NSDictionary *captures = [syntaxItem objectForKey:@"captures"];
                NSString *include = [syntaxItem objectForKey:@"include"];
                NSArray* embedPatterns = [syntaxItem objectForKey:@"patterns"];
                NSArray* capturableScopes = [syntaxItem objectForKey:@"capturableScopes"];
                //case name, match
                if (name && match) {
                    NSArray *a = [self foundPattern:match
                                              range:contentRange];
                    nameMatches = [self merge:@{name: @{@"ranges":a, @"capturableScopes":capturableScopes}}
                                       withd2:nameMatches];
                }
                
                if (captures && match) {
                    captureMatches = [self merge:[self findCaptures:captures
                                                            pattern:match
                                                              range:contentRange]
                                          withd2:captureMatches];
                }
                
                if (beginCaptures && begin) {
                    beginCMatches = [self merge:[self findCaptures:beginCaptures
                                                           pattern:begin
                                                             range:contentRange]
                                         withd2:beginCMatches];
                }
                
                if (endCaptures && end) {
                    endCMatches = [self merge:[self findCaptures:endCaptures
                                                         pattern:end
                                                           range:contentRange]
                                       withd2:endCMatches];
                }
                
                //matching blocks
                if (begin && end) {
                    [self processPairRange:contentRange
                                      item:syntaxItem
                                    output:output];
                } else if (embedPatterns) {
                    [self iterPatternsForRange:contentRange patterns:embedPatterns output:output];
                }
                if (include) {
                    id includes = [self resolveInclude:include];
                    //NSLog(@"recurring for include: %@ with %d %d name:%@",includes, contentRange.location, contentRange.length, name);
                    if (contentRange.length <= [_content length] &&
                        includes) {
                        [self iterPatternsForRange:contentRange
                                          patterns:includes
                                            output:output];
                    }
                }
            }
        });
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (BOOL)whileCondition:(NSRange)brange e:(NSRange)erange cr:(NSRange)contentRange
{
    return (brange.location != NSNotFound &&
            erange.location + erange.length < contentRange.length &&
            erange.location > 0 &&
            !(NSEqualRanges(brange, NSMakeRange(0, 0)) &&
              (NSEqualRanges(erange, NSMakeRange(0, 0)))) &&
            (erange.location < contentRange.length - 1));
}

- (BOOL)fixAnchor:(NSString*)pattern
{
    //return [pattern stringByReplacingOccurrencesOfString:@"\\G" withString:@"\uFFFF"];
    // TODO: pattern for \\z : @"$(?!\n)(?<!\n)"
    return ([pattern rangeOfString:@"\\G"].location != NSNotFound ||
            [pattern rangeOfString:@"\\A"].location != NSNotFound);
}

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
    NSLog(@"nameMatches: %@",nameMatches);
    NSLog(@"captureM: %@",captureMatches);
    NSLog(@"beginM: %@",beginCMatches);
    NSLog(@"endM: %@",endCMatches);
    NSLog(@"pairM: %@",pairMatches);
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
    [self applyStylesTo:output withRanges:pairMatches withTheme:theme];
    [self applyStylesTo:output withRanges:nameMatches withTheme:theme];
    [self applyStylesTo:output withRanges:captureMatches withTheme:theme];
    [self applyStylesTo:output withRanges:beginCMatches withTheme:theme];
    [self applyStylesTo:output withRanges:endCMatches withTheme:theme];
    [self applyStylesTo:output withRanges:contentNameMatches withTheme:theme];
    [self applyStylesTo:output withRanges:overlapMatches withTheme:theme];
}

- (void)execOn:(NSDictionary*)options
{
    _isAlive = YES;
    ArcAttributedString *output = [options objectForKey:@"attributedString"];
    _finalOutput = output;
    NSDictionary* theme = [options objectForKey:@"theme"];
    overlapMatches = [NSDictionary dictionary];

    if (!_matchesDone) {
        NSMutableArray* patterns = [NSMutableArray arrayWithArray:[_bundle objectForKey:@"patterns"]];
        NSDictionary* repo = [_bundle objectForKey:@"repository"];
        for (id k in repo) {
            [patterns addObject:[repo objectForKey:k]];
        }
        
        [self iterPatternsForRange:NSMakeRange(0, [_content length])
                          patterns:patterns
                            output:output];
    
        NSString* foldStart = [_bundle objectForKey:@"foldingStartMarker"];
        NSString* foldEnd = [_bundle objectForKey:@"foldingStopMarker"];

        
        if (foldStart && foldEnd) {
            _foldTree = [CodeFolding foldTreeForContent:_content
                                              foldStart:foldStart
                                                foldEnd:foldEnd
                                             skipRanges:[self rangeArrayForMatches:overlapMatches]
                                               delegate:self];
        }

        _matchesDone = YES;
    }
    
    // tell SH factory to remove self from thread pool.
    [_factory removeFromThreadPool:self];

    [self applyStylesTo:output withTheme:theme];
    [self updateView:output withTheme:theme];
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

- (NSArray *)rangeArrayForMatches:(NSDictionary*)matches
{
    NSMutableArray* res = [NSMutableArray array];
    
    for (NSString* scope in matches) {
        NSArray* ranges = [(NSDictionary*)[matches objectForKey:scope] objectForKey:@"ranges"];
        [res addObjectsFromArray:ranges];
    }
    return res;
}


@end
