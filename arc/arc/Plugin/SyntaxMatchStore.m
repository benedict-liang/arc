//
//  SyntaxMatchStore.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxMatchStore.h"
@interface SyntaxMatchStore ()
@property NSMutableDictionary* store;
@end
@implementation SyntaxMatchStore

-(id)init {
    _store = [NSMutableDictionary dictionary];
    return self;
}
- (void)addParserResult:(SyntaxParserResult *)pres {
    NSMutableDictionary* vals = [_store objectForKey:pres.scope];
    
    if (vals) {
        NSMutableArray* ranges = [vals objectForKey:@"ranges"];
        [ranges addObjectsFromArray:pres.ranges];
    } else {
        NSMutableDictionary* vals = [NSMutableDictionary dictionary];
        [vals setObject:pres.capturableScopes forKey:@"capturableScopes"];
        [vals setObject:pres.ranges forKey:@"ranges"];
        [_store setObject:vals forKey:pres.scope];
    }
}
- (NSArray*)rangesForScope:(NSString*)scope {
    NSMutableArray* ranges = [(NSDictionary*)[_store objectForKey:scope] objectForKey:@"ranges"];
    if (ranges) {
        return [NSArray arrayWithArray:ranges];
    }
    return nil;
}
- (NSArray*)allRanges {
    NSMutableArray* accum = [NSMutableArray array];
    for (id k in _store) {
        [accum addObjectsFromArray:[(NSDictionary*)[_store objectForKey:k] objectForKey:@"ranges"]];
    }
    return accum;
}
- (NSArray*)capturableScopesForScope:(NSString*)scope {
    return [(NSDictionary*)[_store objectForKey:scope] objectForKey:@"capturableScopes"];
}
- (void)mergeWithStore:(SyntaxMatchStore *)store {
    for (NSString* scope in store.store) {
        NSDictionary* val = [store.store objectForKey:scope];
        NSArray* ranges = [val objectForKey:@"ranges"];
        [self addParserResult:[[SyntaxParserResult alloc] initWithScope:scope Ranges:ranges CPS:[val objectForKey:@"capturableScopes"]]];
    }
}
- (NSArray*)scopes {
    NSMutableArray* unsortedKeys = [NSMutableArray arrayWithArray:[_store allKeys]];
    if (!unsortedKeys) {
        return @[];
    }
    [unsortedKeys sortUsingComparator:^NSComparisonResult(id k1, id k2) {
        NSString* s1 = (NSString*)k1;
        NSString* s2 = (NSString*)k2;
        NSArray* cp1 = [self capturableScopesForScope:s1];
        NSArray* cp2 = [self capturableScopesForScope:s2];
        NSArray* overlays = [Constants syntaxOverlays];
        if ([overlays containsObject:cp1[0]] && [overlays containsObject:cp2[0]]) {
            int i1 = [overlays indexOfObject:cp1[0]];
            int i2 = [overlays indexOfObject:cp2[0]];
            if (i1 > i2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    return unsortedKeys;
}
-(NSString*)description {
    return _store.description;
}

- (void)postHook {
    for (NSString* scope in _store) {
        NSMutableDictionary* dict = [_store objectForKey:scope];
        NSArray* cpS = [dict objectForKey:@"capturableScopes"];
    }
}
@end
