//
//  DropBoxFile.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxFile.h"
@interface DropBoxFile ()
@property (nonatomic) NSString *contents;
@end

@implementation DropBoxFile

// Synthesize properties from protocol.
@synthesize name=_name, identifier=_path, parent=_parent, extension=_extension, isRemovable=_isRemovable, size=_size, lastModified=_lastModified;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name identifier:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _extension = [name pathExtension];
        _isRemovable = YES;
    }
    return self;
}

// Returns the contents of this object.
- (NSString *)contents
{
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    DBFile *ourFile = [filesystem openFile:ourPath error:&error];
    
    if (ourFile) {
        NSString *contents = [ourFile readString:&error];
        if (contents) {
            _contents = contents;
        }
    }
    
    if (error) {
        NSLog(@"%@", error);
    }
    [ourFile close];
    return  _contents;
}

// Returns the size of this object.
// Folders should return the number of objects within, Files their size in B.
- (float)size
{
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    
    DBError *error;
    DBFileInfo *fileInfo = [filesystem fileInfoForPath:ourPath error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    if (fileInfo) {
        return [fileInfo size];
    } else {
        return 0;
    }
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    BOOL isRemoveSuccessful = [filesystem deletePath:ourPath error:&error];
    
    if (!isRemoveSuccessful) {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}

@end
