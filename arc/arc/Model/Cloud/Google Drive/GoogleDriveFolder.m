//
//  GoogleDriveFolder.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveFolder.h"

@interface GoogleDriveFolder ()

@property (strong, nonatomic) NSMutableArray *contents;

@end

@implementation GoogleDriveFolder
@synthesize name = _name, path = _path, parent = _parent, isRemovable = _isRemovable, delegate = _delegate;

+ (GoogleDriveFolder *)getRoot
{
    return [[GoogleDriveFolder alloc] initWithName:@"Google Drive" path:@"root" parent:nil];
}

- (id <NSObject>)contents
{
    return _contents;
}

- (id <FileSystemObject>)objectAtPath:(NSString *)path
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)takeFileSystemObject:(id <FileSystemObject>)target
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id <FileSystemObject>)retrieveItemWithName:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id <Folder>)createFolderWithName:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)rename:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (int)size
{
    return [_contents count];
}

- (BOOL)remove
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"GoogleDriveFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
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
        GoogleDriveServiceManager *serviceManager = (GoogleDriveServiceManager *)[GoogleDriveServiceManager sharedServiceManager];
        GTLServiceDrive *driveService = [serviceManager driveService];
        
        for (GTLDriveChildReference *currentReference in children) {
            // Get the child's attributes.
            GTLQuery *attributeQuery = [GTLQueryDrive queryForFilesGetWithFileId:[currentReference identifier]];
            [driveService executeQuery:attributeQuery delegate:self didFinishSelector:@selector(attributesTicket:file:error:)];
        }
    } else {
        NSLog(@"%@", error);
    }
}

// Handles callbacks from a query for a file/folder's attributes.
- (void)attributesTicket:(GTLServiceTicket *)ticket file:(GTLDriveFile *)file error:(NSError *)error
{
    if (!error) {
        NSString *fileName = [file title];
        NSString *filePath = [file downloadUrl];
        NSNumber *fileSize = [file fileSize];
        
        if ([[fileName pathExtension] isEqualToString:@""]) {
            // No extension means this is a folder.
            // Note that folders are retrieved by their identifier, not the download URL.
            GoogleDriveFolder *newFolder = [[GoogleDriveFolder alloc] initWithName:fileName path:[file identifier] parent:self];
            [_contents addObject:newFolder];
        } else {
            // There is a file extension. This must be a file.
            GoogleDriveFile *newFile = [[GoogleDriveFile alloc] initWithName:fileName identifier:filePath size:[fileSize floatValue]];
            [_contents addObject:newFile];
        }
        [_delegate folderContentsUpdated:self];
    } else {
        NSLog(@"%@", error);
    }
}

@end
