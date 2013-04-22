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
    return [_store allKeys];
}
@end
