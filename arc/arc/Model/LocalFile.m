//
//  LocalFile.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LocalFile.h"

@interface LocalFile ()
@property (nonatomic) NSString *contents;
@end

@implementation LocalFile

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent, extension=_extension;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _extension = [name pathExtension];
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    NSError *error;
    NSString *retrievedContents = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
        _contents = retrievedContents;
    }
    return _contents;
}


// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL isRemoveSuccessful = [fileManager removeItemAtPath:_path error:&error];
    
    if (!isRemoveSuccessful) {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}

@end
