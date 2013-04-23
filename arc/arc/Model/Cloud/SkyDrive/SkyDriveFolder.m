//
// Created by Jerome on 14/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveFolder.h"

@interface SkyDriveFolder ()
@property (strong, atomic) NSArray *contents;
@property (strong, atomic) NSArray *operations;
@property (strong, atomic) NSArray *ongoingOperations;
@property (strong, atomic) NSArray *pendingIdentifiers;
@end

@implementation SkyDriveFolder
@synthesize name = _name;
@synthesize identifier = _path;
@synthesize parent = _parent;
@synthesize isRemovable = _isRemovable;
@synthesize delegate = _delegate;
@synthesize size = _size;

+ (id<CloudFolder>)getRoot
{
    return [[SkyDriveFolder alloc] initWithName:@"SkyDrive" identifier:SKYDRIVE_STRING_ROOT_FOLDER parent:nil];
}

- (BOOL)hasOngoingOperations
{
    return [_ongoingOperations count] > 0;
}

- (float)size
{
    return [_contents count];
}

- (int)ongoingOperationCount
{
    return [_ongoingOperations count] + [_pendingIdentifiers count];
}

- (id)initWithName:(NSString *)name identifier:(NSString *)path parent:(id <FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _isRemovable = NO;

        _contents = [NSArray array];
        _ongoingOperations = [NSArray array];
        _pendingIdentifiers = [NSArray array];
    }
    return self;
}

- (void)updateContents
{
    SkyDriveServiceManager *serviceManager = (SkyDriveServiceManager *)[SkyDriveServiceManager sharedServiceManager];
    LiveConnectClient *connectClient = [serviceManager liveClient];
    
    NSNumber *operationState = [NSNumber numberWithInt:kFolderListing];

    LiveOperation *initialOperation = [connectClient getWithPath:[_path stringByAppendingString:SKYDRIVE_STRING_FOLDER_CONTENTS] delegate:self userState:operationState];
    _ongoingOperations = [_ongoingOperations arrayByAddingObject:initialOperation];
    [_delegate folderOperationCountChanged:self];
}

// Triggers when a SkyDrive async operation completes.
// Handles both the listing of folders and retrieval of individual file properties.
- (void)liveOperationSucceeded:(LiveOperation *)operation
{
    NSDictionary *result = [operation result];
    
    int state = [[operation userState] intValue];
    switch (state) {
        case kFolderListing: {
            _pendingIdentifiers = [result valueForKey:@"data"];
        }
            break;
        case kFileInfo: {
            NSString *name = [result valueForKey:@"name"];
            NSString *identifier = [result valueForKey:@"id"];
            
            NSArray *filteredArray = [_contents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [[(id<FileSystemObject>)evaluatedObject identifier] isEqualToString:identifier];
            }]];
            if ([filteredArray count] == 0) {
                if ([identifier hasPrefix:@"file"]) {
                    NSString *size = [result valueForKey:@"size"];
                    SkyDriveFile *newFile = [[SkyDriveFile alloc] initWithName:name identifier:identifier size:[size floatValue]];
                    _contents = [_contents arrayByAddingObject:newFile];
                } else if ([identifier hasPrefix:@"folder"]) {
                    SkyDriveFolder *newFolder = [[SkyDriveFolder alloc] initWithName:name identifier:identifier parent:self];
                    _contents = [_contents arrayByAddingObject:newFolder];
                }
                [_delegate folderContentsUpdated:self];
            }
        }
            break;
    }
    NSMutableArray *newOperations = [NSMutableArray arrayWithArray:_ongoingOperations];
    [newOperations removeObject:operation];
    _ongoingOperations = newOperations;
    [_delegate folderOperationCountChanged:self];
    [self startNextPendingOperation];
}

- (void)liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    switch ([error code]) {
        case 1:
            // The operation was cancelled. Do nothing.
            break;
        default:
            NSLog(@"%@", error);
            NSMutableArray *newOperations = [NSMutableArray arrayWithArray:_ongoingOperations];
            [newOperations removeObject:operation];
            _ongoingOperations = newOperations;
            [_delegate folderOperationCountChanged:self];
            [self startNextPendingOperation];
            break;
    }
}

- (void)startNextPendingOperation
{
    while ([_ongoingOperations count] < CLOUD_MAX_CONCURRENT_DOWNLOADS && [_pendingIdentifiers count] > 0) {
        NSDictionary *currentFileDetails = [_pendingIdentifiers objectAtIndex:0];
        NSMutableArray *mutableCopy = [_pendingIdentifiers mutableCopy];
        [mutableCopy removeObjectAtIndex:0];
        _pendingIdentifiers = mutableCopy;
        
        SkyDriveServiceManager *serviceManager = (SkyDriveServiceManager *)[SkyDriveServiceManager sharedServiceManager];
        LiveConnectClient *connectClient = [serviceManager liveClient];
        
        NSNumber *operationType = [NSNumber numberWithInt:kFileInfo];
        LiveOperation *currentOperation = [connectClient getWithPath:[currentFileDetails valueForKey:@"id"] delegate:self userState:operationType];
        _ongoingOperations = [_ongoingOperations arrayByAddingObject:currentOperation];
        [_delegate folderOperationCountChanged:self];
    }
}

- (void)cancelOperations
{
    for (LiveOperation *currentOperation in _ongoingOperations) {
        [currentOperation cancel];
    }
    _ongoingOperations = [NSArray array];
    _pendingIdentifiers = [NSArray array];
    [_delegate folderOperationCountChanged:self];
}

@end