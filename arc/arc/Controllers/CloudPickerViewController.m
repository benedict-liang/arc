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

// TableView-related properties.
@property UITableView *tableView;
@property NSArray *segregatedContents;

// Download-related properties.
@property (strong, nonatomic) id<CloudFolder> folder;
@property (weak, nonatomic) id<CloudServiceManager>serviceManager;
@property (weak, nonatomic) LocalFolder *target;
@end

@implementation CloudPickerViewController

- (id)initWithCloudFolder:(id<CloudFolder>)folder targetFolder:(LocalFolder *)target serviceManager:(id<CloudServiceManager>)serviceManager
{
    if (self = [super init]) {
        _folder = folder;
        _target = target;
        _serviceManager = serviceManager;
        [folder setDelegate:self];
        [folder updateContents];
    }
    return self;
}

- (void)separateFilesAndFolders
{
    NSMutableArray *folders = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    NSArray *fileObjects = (NSArray*)[_folder contents];
    
    for (id<FileSystemObject> fileSystemObject in fileObjects) {
        if ([[fileSystemObject class] conformsToProtocol:@protocol(CloudFile)]) {
            [files addObject:fileSystemObject];
        } else if ([[fileSystemObject class] conformsToProtocol:@protocol(CloudFolder) ]) {
            [folders addObject:fileSystemObject];
        }
    }
    _segregatedContents = [NSArray arrayWithObjects:folders, files, nil];
}

- (void)folderContentsUpdated:(id<Folder>)sender
{
    [self separateFilesAndFolders];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:[_folder name]];
    
    _closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(shouldClose)];
//    NSArray *buttonArray = [NSArray arrayWithObjects:_closeButton, [self editButtonItem], nil];
    
//    [[self navigationItem] setRightBarButtonItems:buttonArray];
    [[self navigationItem] setRightBarButtonItem:_closeButton];
    
    // Subview properties.
    [[self view] setAutoresizesSubviews:YES];
    
    // Create the Table View.
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:_tableView];
    
    // Create the loading overlay.
    _loadingOverlayController = [[LoadingOverlayViewController alloc] initWithFrame:[[self view] bounds]];
//    [[self view] insertSubview:[_loadingOverlayController view] aboveSubview:_tableView];
}

- (void)shouldClose
{
    [_folder cancelOperations];
    [_delegate cloudPickerDone:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Returns the number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_segregatedContents count];
}

// Returns the number of rows in the given section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_segregatedContents objectAtIndex:section] count];
}

// Returns the header for the given section.
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 22.0)];
    customView.backgroundColor = [Utils colorWithHexString:@"CC272821"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = section == 0 ? @"Folders" : @"Files";
    [customView addSubview:headerLabel];
    return customView;
}

// Set up the cell at the given index path.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [_segregatedContents objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [section objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier;
    if ([[fileObject class] conformsToProtocol:@protocol(File)]) {
        cellIdentifier = (NSString *)FILECELL_REUSE_IDENTIFIER;
    } else if ([[fileObject class] conformsToProtocol:@protocol(Folder)]) {
        cellIdentifier = (NSString *)FOLDERCELL_REUSE_IDENTIFIER;
    }
    
    FileObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FileObjectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:cellIdentifier];
    }
    
    [cell setFileSystemObject:fileObject];

    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [_segregatedContents objectAtIndex:[indexPath section]];
    id selectedObject = [section objectAtIndex:[indexPath row]];
    
    if ([selectedObject conformsToProtocol:@protocol(CloudFile)]) {
        [_serviceManager downloadFile:selectedObject toFolder:_target];
    } else {
        CloudPickerViewController *newFolderController = [[CloudPickerViewController alloc] initWithCloudFolder:selectedObject targetFolder:_target serviceManager:_serviceManager];
        [newFolderController setDelegate:_delegate];
        [[self navigationController] pushViewController:newFolderController animated:YES];
    }
}

@end
