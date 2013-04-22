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
    NSMutableArray* ranges = [_store objectForKey:pres.scope];
    if (ranges) {
        [ranges addObjectsFromArray:pres.ranges];
    } else {
        [_store setObject:pres.ranges forKey:pres.scope];
    }
}
- (NSArray*)rangesForScope:(NSString*)scope {
    NSMutableArray* ranges = [_store objectForKey:scope];
    if (ranges) {
        return [NSArray arrayWithArray:ranges];
    }
    return nil;
}

- (void)mergeWithStore:(SyntaxMatchStore *)store {
    for (NSString* scope in store.store) {
        NSArray* ranges = [store rangesForScope:scope];
        [self addParserResult:[[SyntaxParserResult alloc] initWithScope:scope Ranges:ranges]];
    }
}
@end
