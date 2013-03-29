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
                              @"name", [NSValue valueWithPointer:@selector(foo)],
                              @"begin", @"",
                              @"end", @"",
                              @"captures", @"",
                              @"beginCaptures", @"",
                              @"endCaptures", @"",
                              @"repository", @"",
                              @"include", [NSValue valueWithPointer:@selector(resolveInclude:)],
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
        NSLog(@"repo: %@", _repositories);
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

- (id)resolveInclude:(NSString*)includeString {
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

@end
