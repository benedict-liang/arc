//
//  Grammar.m
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleGrammar.h"

@interface TMBundleGrammar()

@property NSDictionary *repositories;

@end

@implementation TMBundleGrammar
@synthesize repositories = _repositories;

// Suppress warning for performSelector with ARC
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (NSDictionary*)getRuleKeysDictionary {
    static NSDictionary *ruleKeysDictionary;
    
    if (ruleKeysDictionary == nil) {
        ruleKeysDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"name",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"begin",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"end",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"match",
                              [NSValue valueWithPointer:@selector(resolveDeletes:)], @"comment",
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"captures",
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"beginCaptures", 
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"endCaptures",
                              [NSValue valueWithPointer:@selector(resolvePatterns:)], @"patterns",
                              [NSValue valueWithPointer:@selector(resolveInclude:)], @"include",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"contentName",
                              nil];
    }
    
    return ruleKeysDictionary;
}

#pragma mark - Initialisation

- (id)initWithPlist:(NSDictionary*)plist {
    return [self initWithPlists:[NSArray arrayWithObject:plist]];
}

- (id)initWithPlists:(NSArray*)pListsArray {
    self = [super init];
    
    if (self != nil) {
        [self initializeRepository:pListsArray];
    }
    
    return self;
}

- (void)initializeRepository:(NSArray*)pListsArray {
    //combine repositories of all plists
    NSMutableDictionary *tempRepositoryDictionary = [[NSMutableDictionary alloc] init];
    for (NSDictionary *plist in pListsArray) {
        NSDictionary *currentRepository = [plist objectForKey:@"repository"];
        [tempRepositoryDictionary addEntriesFromDictionary:currentRepository];
    }
    
    _repositories = [NSDictionary dictionaryWithDictionary:tempRepositoryDictionary];
}

#pragma mark - Grammar Processing

- (id)resolveReturnValue:(id)value {
    return value;
}

- (id)resolveDeletes:(id)value {
    return nil;
}

- (id)resolveCaptures:(id)value {
    //return an array of scopes
    if (![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *capturesDictionary = (NSDictionary*)value;
    NSMutableArray *capturesArray = [[NSMutableArray alloc] init];
    
    for (NSString *key in [capturesDictionary allKeys]) {
        NSDictionary *capture = [capturesDictionary objectForKey:key];
        NSString *scope = [capture objectForKey:@"name"];
        
        if (scope != nil) {
            [capturesArray addObject:scope];
        }
    }
    
    if ([capturesArray count] == 0) {
        return nil;
    }
    return [NSArray arrayWithArray:capturesArray];
}

- (id)resolvePatterns:(id)value {
    if (![value isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *patternsArray = (NSArray*)value;
    NSMutableArray *processedPatternsArray = [[NSMutableArray alloc] init];

    for (NSDictionary *dict in patternsArray) {
        NSMutableDictionary *processedPatternItem = [[NSMutableDictionary alloc] init];
        for (NSString *key in [dict allKeys]) {
            id result = [self parseGrammar:key withValue:[dict objectForKey:key]];
            if (result != nil) {
                if (![key isEqualToString:@"include"]) {
                    [processedPatternItem setObject:result forKey:key];
                }
                
                NSDictionary *processedInclude = [self processRecursiveInclude:result];
                if (processedInclude != nil) {
                    [processedPatternItem addEntriesFromDictionary:processedInclude];
                }
            }
        }
        
        if ([processedPatternItem count] != 0) {
            [processedPatternsArray addObject:[NSDictionary dictionaryWithDictionary:processedPatternItem]];
        }
    }
    
    return [NSArray arrayWithArray:processedPatternsArray];
}

- (NSDictionary*)processRecursiveInclude:(id)result {
    if (![result isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *resultDict = (NSDictionary*)result;
    id value = [resultDict objectForKey:@"patterns"];
    
    if (value == nil) {
        return nil;
    }
    
    id processedResult = [self parseGrammar:@"patterns" withValue:value];
    
    if ([processedResult isKindOfClass:[NSArray class]]) {
        NSArray *temp = (NSArray*)processedResult;

        if ([temp count] == 0) {
            return nil;
        }
        return (NSDictionary*)[temp objectAtIndex:0];
    }
    
    return nil;
}

// Replaces includes with related variable values
- (id)resolveInclude:(id)value {
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *includeString = (NSString*)value;
    
    // Handles 3 types of includes
    if ([includeString isEqualToString:@"$self"]) {
        // TODO: Skip $self for now
        return nil;
    }
    else if ([includeString characterAtIndex:0] == '#') {
        // Get rule from repository
        NSString *str = [includeString substringFromIndex:1];
        NSDictionary *rule = [self getRuleFromRepository:str];
        if (rule) {
            return rule;
        }
        return nil;
        
    }
    else {
        //TODO: find scope name of another language
        return nil;
    }
}

- (NSDictionary*)getRuleFromRepository:(NSString*)repositoryName {
    if (_repositories == nil) {
        return nil;
    }
    
    return [_repositories objectForKey:repositoryName];
}


#pragma mark - Public API

- (id)parseGrammar:(NSString*)key withValue:(id)value {
    NSValue *ruleAction = [[TMBundleGrammar getRuleKeysDictionary] objectForKey:key];
    
    SEL selector = [ruleAction pointerValue];

    if (!selector) {
        return [self performSelector:@selector(resolveReturnValue:) withObject:value];
    }

    return [self performSelector:selector withObject:value];
}

// Suppress warning for performSelector with ARC
#pragma clang diagnostic pop

@end
