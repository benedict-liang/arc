//
// Created by Jerome on 14/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveFolder.h"


@implementation SkyDriveFolder
- (id <NSObject>)contents
{
    return nil;
}

- (id <FileSystemObject>)objectAtPath:(NSString *)path
{
    return nil;
}

- (BOOL)takeFileSystemObject:(id <FileSystemObject>)target
{
    return NO;
}

- (id <FileSystemObject>)retrieveItemWithName:(NSString *)name
{
    return nil;
}

- (id <Folder>)createFolderWithName:(NSString *)name
{
    return nil;
}

- (BOOL)rename:(NSString *)name
{
    return NO;
}

- (int)size
{
    return 0;
}

- (BOOL)remove
{
    return NO;
}

- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id <FileSystemObject>)parent
{
    return nil;
}


@end