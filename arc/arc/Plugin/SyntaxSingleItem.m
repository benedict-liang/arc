//
//  SyntaxSingleItem.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxSingleItem.h"

@implementation SyntaxSingleItem
@synthesize name=_name, capturableScopes = _capturableScopes;
- (id)initWithName:(NSString *)name Match:(NSString *)match Captures:(NSDictionary*)captures CapturableScopes:(NSArray*)cpS{
    if (self = [super init]) {
        _name = name;
        _match = match;
        _capturableScopes = cpS;
        _captures = captures;
    }
    return self;
}
@end
