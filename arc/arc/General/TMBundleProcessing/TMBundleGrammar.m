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

+ (NSDictionary*)getRuleKeysDictionary {
    static NSDictionary *ruleKeysDictionary;
    
    if (ruleKeysDictionary == nil) {
        ruleKeysDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"name",//[NSValue valueWithPointer:@selector(foo)],
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"begin",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"end",
                              [NSValue valueWithPointer:@selector(resolveReturnValue:)], @"match",
                              [NSValue valueWithPointer:@selector(resolveDeletes:)], @"comment",
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"captures",
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"beginCaptures", 
                              [NSValue valueWithPointer:@selector(resolveCaptures:)], @"endCaptures",
                              // TODO: implement method to resolve patterns
                              [NSValue valueWithPointer:@selector(resolvePatterns:)], @"patterns",
                              [NSValue valueWithPointer:@selector(resolveInclude:)], @"include",
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
        //Skip $self for now
        return nil;
    }
    else if ([includeString characterAtIndex:0] == '#') {
        // Get rule from repository
        NSDictionary *rule = [self getRuleFromRepository:[includeString substringFromIndex:1]];
        return rule;
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
    return [self performSelector:selector withObject:value];
}

@end
