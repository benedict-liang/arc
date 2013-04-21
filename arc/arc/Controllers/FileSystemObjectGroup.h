//
//  FileSystemObjectGroup.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemObjectGroup : NSObject

- (id)initWithName:(NSString *)groupName;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSInteger length;
@property (nonatomic, readonly) NSString *groupName;

- (void)addFileSystemObject:(id<FileSystemObject>)fileSystemObject;
- (void)removeFileSystemObject:(id<FileSystemObject>)fileSystemObject;
@end
