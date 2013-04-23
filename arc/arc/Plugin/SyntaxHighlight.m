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

- (void)applyStylesTo:(ArcAttributedString*)output
           withRanges:(SyntaxMatchStore*)pairs
            withTheme:(NSDictionary*)theme
{
    if (pairs) {
        for (NSString* scope in pairs.scopes) {
            //NSLog(@"%@",pairs.scopes);
            NSArray* ranges = [pairs rangesForScope:scope];
            NSArray* capturableScopes = [pairs capturableScopesForScope:scope];
            if (!capturableScopes) {
                capturableScopes = [self capturableScopes:scope];
            }
            if ([_overlays containsObject:capturableScopes[0]] && ![pairs isEqual:_overlapStore]) {
                [_overlapStore addParserResult:[[SyntaxParserResult alloc] initWithScope:scope Ranges:ranges CPS:capturableScopes]];
                continue;
            }
//            if ([[capturableScopes objectAtIndex:0] isEqualToString:@"meta"]) {
//                NSLog(@"arrgh");
//            }
            
            NSDictionary* styleScopes = [theme objectForKey:@"scopes"];
            //NSLog(@"%@",capturableScopes);
           // NSLog(@"%@",styleScopes);
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


- (void)applyForeground:(ArcAttributedString*)output withTheme:(NSDictionary*)theme
{
    NSDictionary* global = [theme objectForKey:@"global"];
    UIColor* foreground = [global objectForKey:@"foreground"];
    if (foreground) {
        [output setForegroundColor:foreground OnRange:NSMakeRange(0, _content.length) ForSetting:SYNTAX_KEY];
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

  //  if (!_matchesDone) {

        _matchStore = [_syntaxPatterns parseResultsForContent:_content Range:NSMakeRange(0, _content.length)];
        //NSLog(@"%@",_matchStore);
        
        [self applyStylesTo:output withTheme:theme];
    
        [self setupFoldTree];
        [self updateView:output withTheme:theme];
        NSLog(@"view updated!");
   //     _matchesDone = YES;
   // }
    
    // tell SH factory to remove self from thread pool.
    //[_factory removeFromThreadPool:self];

}

- (void)renderOn:(NSDictionary *)options {
     NSDictionary* theme = [options objectForKey:@"theme"];
    ArcAttributedString *output = [options objectForKey:@"attributedString"];
    [self applyStylesTo:output withTheme:theme];
     [self updateView:output withTheme:theme];
}
- (void)kill
{
    _isAlive = NO;
    _matchesDone = NO;
}

//- (void)testFoldsOnFoldRanges:(NSArray*)fR
//                   foldStarts:(NSArray*)fS
//                     foldEnds:(NSArray*)fE
//{
// 
//    for (NSValue*v in fR) {
//        NSRange r;
//        [v getValue:&r];
//        [self styleOnRange:r fcolor:[UIColor yellowColor] output:_finalOutput];
//    }
//    //NSLog(@"_foldStarts: %@",_foldStarts);
//    for (NSValue* v in fS) {
//        NSRange r;
//        [v getValue:&r];
//        [self styleOnRange:r fcolor:[UIColor redColor] output:_finalOutput];
//    }
//    
//    //NSLog(@"_foldEnds: %@",_foldEnds);
//    for (NSValue*v in fE) {
//        NSRange r;
//        [v getValue:&r];
//        [self styleOnRange:r fcolor:[UIColor greenColor] output:_finalOutput];
//    }
//    
//}



@end
