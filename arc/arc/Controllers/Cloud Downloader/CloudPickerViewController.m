//
//  CloudPickerViewController.m
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CloudPickerViewController.h"

@interface CloudPickerViewController ()
// Loading Overlay view.
@property LoadingOverlayViewController *loadingOverlayController;

// View properties.
@property UIBarButtonItem *closeButton;
@property UIAlertView *closeAlert;

// Download-related properties.
@property (strong, nonatomic) id<CloudFolder> folder;
@property (weak, nonatomic) id<CloudServiceManager>serviceManager;
@property (weak, nonatomic) LocalFolder *target;
@end

@implementation CloudPickerViewController

- (id)initWithCloudFolder:(id<CloudFolder>)folder
             targetFolder:(LocalFolder *)target
           serviceManager:(id<CloudServiceManager>)serviceManager
{
    if (self = [super initWithFolder:folder]) {
        _target = target;
        _serviceManager = serviceManager;
        [serviceManager setDelegate:self];
        [folder setDelegate:self];
        [folder updateContents];
    }
    return self;
}

- (void)setUpFolderContents
{
    NSArray *fileObjects = (NSArray*)self.folder.contents;
    FileSystemObjectGroup *files = [[FileSystemObjectGroup alloc] initWithName:FOLDER_VIEW_FILES];
    FileSystemObjectGroup *folders = [[FileSystemObjectGroup alloc] initWithName:FOLDER_VIEW_FOLDERS];

    for (id<FileSystemObject> fileSystemObject in fileObjects) {
        if ([[fileSystemObject class] conformsToProtocol:@protocol(CloudFile)]) {
            [files addFileSystemObject:fileSystemObject];
        } else if ([[fileSystemObject class] conformsToProtocol:@protocol(CloudFolder) ]) {
            [folders addFileSystemObject:fileSystemObject];
        }
    }
    
    [self setFilesAndFolders:@[folders, files]];
}

- (void)fileStatusChangedForService:(id)sender
{
    [self updateView];
}

- (void)folderContentsUpdated:(id<Folder>)sender
{
    [self updateView];
}

- (void)updateView
{
    [self setUpFolderContents];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _closeButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(shouldClose:)];
    self.navigationItem.rightBarButtonItem = _closeButton;
    self.view.autoresizesSubviews = YES;
    self.navigationItem.title = self.folder.name;
    
    // Create the Table View.
    [self setUpTableView];
    
    // Create the loading overlay.
    _loadingOverlayController =
    [[LoadingOverlayViewController alloc] initWithFrame:[[self view] bounds]];
//    [[self view] insertSubview:[_loadingOverlayController view] aboveSubview:_tableView];
}

- (void)shouldClose:(id)sender
{
    if ([self.folder hasOngoingOperations]) {
        _closeAlert = [[UIAlertView alloc] initWithTitle:@"Downloads in Progress" message:@"Closing this picker will cancel any ongoing downloads." delegate:self cancelButtonTitle:@"Stay Here" otherButtonTitles:@"Close Picker", nil];
        [_closeAlert show];
    } else {
        [_delegate modalViewControllerDone:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.folder cancelOperations];
            [_delegate modalViewControllerDone:nil];
            break;
            
        default:
            break;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> selectedObject = [self sectionItem:indexPath];
    if ([selectedObject conformsToProtocol:@protocol(CloudFile)]) {
        if ([Utils isFileSupported:[selectedObject name]]) {
            [_serviceManager downloadFile:(id<CloudFile>)selectedObject
                                 toFolder:_target];
            [self folderContentsUpdated:self.folder];
        } else {
            [Utils showUnsupportedFileDialog];
        }
    } else {
        CloudPickerViewController *newFolderController =
        [[CloudPickerViewController alloc] initWithCloudFolder:(id<CloudFolder>)selectedObject
                                                  targetFolder:_target
                                                serviceManager:_serviceManager];
        [newFolderController setDelegate:_delegate];
        [[self navigationController] pushViewController:newFolderController
                                               animated:YES];
    }
}

@end
