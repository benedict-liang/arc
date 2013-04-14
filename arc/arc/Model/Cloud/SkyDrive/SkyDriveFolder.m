//
// Created by Jerome on 14/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveFolder.h"

@interface SkyDriveFolder ()

@property (strong, nonatomic) NSMutableArray *contents;

@end


@implementation SkyDriveFolder
@synthesize name = _name, path = _path, parent = _parent, isRemovable = _isRemovable;

- (id <NSObject>)contents
{
    return _contents;
}

- (id <FileSystemObject>)objectAtPath:(NSString *)path
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)takeFileSystemObject:(id <FileSystemObject>)target
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id <FileSystemObject>)retrieveItemWithName:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id <Folder>)createFolderWithName:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)rename:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (int)size
{
    return [_contents count];
}

- (BOOL)remove
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id <FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _isRemovable = NO;

        _contents = [NSMutableArray array];
    }
    return self;
}


@end