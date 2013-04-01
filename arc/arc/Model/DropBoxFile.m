//
//  DropBoxFile.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxFile.h"

@implementation DropBoxFile

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent, needsRefresh=_needsRefresh, extension=_extension;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _extension = [name pathExtension];
        _needsRefresh = YES;
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    if (_needsRefresh) {
        return [self refreshContents];
    } else {
        return _contents;
    }
}

// Refreshes the contents of this object, and returns them (for convenience.)
- (id<NSObject>)refreshContents
{
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    DBFile *ourFile = [filesystem openFile:ourPath error:&error];
    
    if (ourFile) {
        NSString *contents = [ourFile readString:&error];
        if (contents) {
            _contents = contents;
            _needsRefresh = NO;
        }
    }
    
    if (error) {
        NSLog(@"%@", error);
    }
    return  _contents;
}

// Marks this object as needing to be refreshed.
- (void)markNeedsRefresh
{
    _needsRefresh = YES;
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
    
    if (isRemoveSuccessful) {
        [_parent markNeedsRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}

@end
