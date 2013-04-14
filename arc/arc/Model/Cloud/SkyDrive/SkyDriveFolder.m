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

+ (SkyDriveFolder *)getRoot
{
    return [[SkyDriveFolder alloc] initWithName:@"SkyDrive Documents" path:@"me/skydrive" parent:nil];
}

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
        [self updateContents];
    }
    return self;
}

- (void)updateContents
{
    SkyDriveServiceManager *serviceManager = (SkyDriveServiceManager *)[SkyDriveServiceManager sharedServiceManager];
    LiveConnectClient *connectClient = [serviceManager liveClient];
    
    NSDictionary *operationState = @{@"operationType" : [NSNumber numberWithInt:kFolderListing]};

    [connectClient getWithPath:[_path stringByAppendingString:@"/files"] delegate:self userState:operationState];
}

// Triggers when a SkyDrive async operation completes.
// Handles both the listing of folders and retrieval of individual file properties.
- (void)liveOperationSucceeded:(LiveOperation *)operation
{
    SkyDriveServiceManager *serviceManager = (SkyDriveServiceManager *)[SkyDriveServiceManager sharedServiceManager];
    LiveConnectClient *connectClient = [serviceManager liveClient];
    
    NSDictionary *result = [operation result];
    
    int state = [[[operation userState] valueForKey:@"operationType"] intValue];
    switch (state) {
        case kFolderListing: {
            NSArray *fileDictionaries = [result valueForKey:@"data"];
            for (NSDictionary *currentDictionary in fileDictionaries) {
                NSDictionary *operationState = @{
                                                 @"operationType" : [NSNumber numberWithInt:kFileInfo],
                                                 @"retrievedType" : [currentDictionary valueForKey:@"type"]
                                                 };
                [connectClient getWithPath:[currentDictionary valueForKey:@"id"] delegate:self userState:operationState];
            }
        }
            break;
        case kFileInfo: {
            NSString *type = [[operation userState] valueForKey:@"retrievedType"];
            NSString *name = [result valueForKey:@"name"];
            NSString *path = [result valueForKey:@"id"];
            
            if ([type isEqualToString:@"file"]) {
                SkyDriveFile *newFile = [[SkyDriveFile alloc] initWithName:name path:path parent:self];
                [_contents addObject:newFile];
            } else if ([type isEqualToString:@"folder"]) {
                SkyDriveFolder *newFolder = [[SkyDriveFolder alloc] initWithName:name path:path parent:self];
                [_contents addObject:newFolder];
            } else {
                // Do nothing. This is audio, a photo, or a video.
            }
            [_delegate folderContentsUpdated:self];
        }
            break;
    }
}

@end