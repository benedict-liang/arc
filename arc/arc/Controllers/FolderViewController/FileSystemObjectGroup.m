//
//  FileSystemObjectGroup.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileSystemObjectGroup.h"

@interface FileSystemObjectGroup ()
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *_items;
@end

@implementation FileSystemObjectGroup

- (id)initWithName:(NSString *)groupName
{
    self = [super init];
    if (self) {
        __items = [NSMutableArray array];
        _groupName = groupName;
    }
    return self;
}

- (NSString *)groupName
{
    return _groupName;
}

- (void)addFileSystemObject:(id<FileSystemObject>)fileSystemObject
{
    [__items addObject:fileSystemObject];
    [__items sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] compare:[obj2 name] options:NSCaseInsensitiveSearch];
    }];
}

- (void)removeFileSystemObject:(id<FileSystemObject>)fileSystemObject
{
    [__items removeObject:fileSystemObject];
}

- (NSInteger)length
{
    return [__items count];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:__items];
}
@end
