//
//  GoogleDriveFolder.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveFolder.h"

@interface GoogleDriveFolder ()
@property (strong, atomic) NSArray *contents;
@property (strong, atomic) NSArray *ongoingOperations;
@property (strong, atomic) NSArray *pendingIdentifiers;
@end

@implementation GoogleDriveFolder
@synthesize name = _name;
@synthesize identifier = _path;
@synthesize parent = _parent;
@synthesize isRemovable = _isRemovable;
@synthesize delegate = _delegate;
@synthesize size = _size;

+ (GoogleDriveFolder *)getRoot
{
    return [[GoogleDriveFolder alloc] initWithName:@"Google Drive" identifier:@"root" parent:nil];
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

- (void)cancelOperations
{
    for (GTLServiceTicket *currentTicket in _ongoingOperations) {
        [currentTicket cancelTicket];
    }
    _ongoingOperations = [NSArray array];
    _pendingIdentifiers = [NSArray array];
    [_delegate folderOperationCountChanged:self];
}

- (void)updateContents
{
    GoogleDriveServiceManager *serviceManager = (GoogleDriveServiceManager *)[GoogleDriveServiceManager sharedServiceManager];
    GTLServiceDrive *driveService = [serviceManager driveService];
    
    GTLQuery *folderContentsQuery = [GTLQueryDrive queryForChildrenListWithFolderId:_path];
    
    [driveService executeQuery:folderContentsQuery delegate:self didFinishSelector:@selector(contentsTicket:children:error:)];
}

// Handles callbacks from a query for a folder's children.
- (void)contentsTicket:(GTLServiceTicket *)ticket children:(GTLDriveChildList *)children error:(NSError *)error
{
    if (!error) {
        _pendingIdentifiers = [children items];
        NSMutableArray *newOperations = [NSMutableArray arrayWithArray:_ongoingOperations];
        [newOperations removeObject:ticket];
        _ongoingOperations = newOperations;
        [_delegate folderOperationCountChanged:self];
        [self startNextPendingOperation];
    } else {
        [self handleError:error];
    }
}

// Handles callbacks from a query for a file/folder's attributes.
- (void)attributesTicket:(GTLServiceTicket *)ticket file:(GTLDriveFile *)file error:(NSError *)error
{
    if (!error) {
        NSString *fileName = [file title];
        NSString *filePath = [file downloadUrl];
        NSNumber *fileSize = [file fileSize];
        NSString *fileType = [file mimeType];
        NSString *fileIdentifier = [file identifier];
        
        NSArray *filteredArray = [_contents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[evaluatedObject class] conformsToProtocol:@protocol(Folder)]) {
                return [[evaluatedObject identifier] isEqualToString:fileIdentifier];
            } else {
                return [[evaluatedObject identifier] isEqualToString:filePath];
            }
        }]];
        if ([filteredArray count] == 0) {
            if ([fileType isEqualToString:@"application/vnd.google-apps.folder"]) {
                // This is a folder.
                // Note that folders are retrieved by their identifier, not the download URL.
                GoogleDriveFolder *newFolder = [[GoogleDriveFolder alloc] initWithName:fileName identifier:fileIdentifier parent:self];
                _contents = [_contents arrayByAddingObject:newFolder];
            } else {
                // This must be a file. Add it if we have a download URL.
                if (filePath != nil) {
                    GoogleDriveFile *newFile = [[GoogleDriveFile alloc] initWithName:fileName identifier:filePath size:[fileSize floatValue]];
                    _contents = [_contents arrayByAddingObject:newFile];
                }
            }
            [_delegate folderContentsUpdated:self];
        }
    } else {
        [self handleError:error];
    }
    
    NSMutableArray *newOperations = [NSMutableArray arrayWithArray:_ongoingOperations];
    [newOperations removeObject:ticket];
    _ongoingOperations = [NSArray arrayWithArray:newOperations];
    [_delegate folderOperationCountChanged:self];
    [self startNextPendingOperation];
}

- (void)startNextPendingOperation
{
    while ([_ongoingOperations count] < CLOUD_MAX_CONCURRENT_DOWNLOADS && [_pendingIdentifiers count] > 0) {
        GTLDriveChildReference *currentReference = [_pendingIdentifiers objectAtIndex:0];
        NSMutableArray *mutableCopy = [_pendingIdentifiers mutableCopy];
        [mutableCopy removeObjectAtIndex:0];
        _pendingIdentifiers = mutableCopy;
        
        GoogleDriveServiceManager *serviceManager = (GoogleDriveServiceManager *)[GoogleDriveServiceManager sharedServiceManager];
        GTLServiceDrive *driveService = [serviceManager driveService];
        
        GTLQuery *attributeQuery = [GTLQueryDrive queryForFilesGetWithFileId:[currentReference identifier]];
        GTLServiceTicket *currentTicket = [driveService executeQuery:attributeQuery delegate:self didFinishSelector:@selector(attributesTicket:file:error:)];
        _ongoingOperations = [_ongoingOperations arrayByAddingObject:currentTicket];
        [_delegate folderOperationCountChanged:self];
    }
}

- (void)handleError:(NSError *)error
{
    int errorCode = [error code];
    switch (errorCode) {
        case 400:
        case 401:
            [_delegate folderReportsAuthFailed:self];
            break;
        default:
            NSLog(@"%@", error);
            break;
    }
}

@end
