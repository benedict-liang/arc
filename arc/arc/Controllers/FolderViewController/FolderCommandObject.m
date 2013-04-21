//
//  FolderCommandObject.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FolderCommandObject.h"

@implementation FolderCommandObject
@synthesize type = _type;
@synthesize target = _target;

-(id)initWithType:(kFolderCommandType)type andTarget:(id)target
{
    self = [super init];
    if (self) {
        _type = type;
        _target = target;
    }
    return self;
}

+ (FolderCommandObject*)commandOfType:(kFolderCommandType)type withTarget:(id)target
{
    return [[FolderCommandObject alloc] initWithType:type
                                           andTarget:target];
}

@end
