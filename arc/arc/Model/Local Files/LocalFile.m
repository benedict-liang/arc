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
@synthesize name=_name, identifier=_identifier, parent=_parent, extension=_extension, isRemovable=_isRemovable, size=_size, lastModified=_lastModified, isAvailable=_isAvailable;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name identifier:(NSString *)identifier parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _identifier = identifier;
        _parent = parent;
        _extension = [name pathExtension];
        _isRemovable = [[Constants privilegedFileList] indexOfObject:_name] == NSNotFound;
        _isAvailable = YES;
        [self updateAttributes];
    }
    return self;
}

// Updates the attributes of this file.
- (void)updateAttributes
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    NSDictionary *fileProperties = [fileManager attributesOfItemAtPath:_identifier error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
        _size = [[fileProperties valueForKey:NSFileSize] floatValue];
        _lastModified = [fileProperties valueForKey:NSFileModificationDate];
    }
}

// Returns the contents of this object.
- (NSString *)contents
{
    NSError *error;
    NSString *retrievedContents = [NSString stringWithContentsOfFile:_identifier encoding:NSUTF8StringEncoding error:&error];
    
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
    BOOL isRemoveSuccessful = [fileManager removeItemAtPath:_identifier error:&error];
    
    if (!isRemoveSuccessful) {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}

@end
