//
//  CloudPickerViewController.m
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CloudPickerViewController.h"

@interface CloudPickerViewController ()
// TableView-related properties.
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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = [_folder name];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Hide section title if section has zero rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    return section == 0 ? @"Folders" : @"Files";
}

// Set up the cell at the given index path.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSString *detailDescription;
    UIImage *cellImage;
    
    NSArray *section = [_segregatedContents objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [section objectAtIndex:indexPath.row];
    
    if ([[fileObject class] conformsToProtocol:@protocol(CloudFile)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"file.png"]
                          toSize:CGSizeMake(40, 40)];
        detailDescription = [Utils humanReadableFileSize:[(id<CloudFile>)fileObject fileSize]];
    } else if ([[fileObject class] conformsToProtocol:@protocol(CloudFolder)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"folder.png"]
                          toSize:CGSizeMake(40, 40)];
    }
    
    cell.textLabel.text = fileObject.name;
    cell.imageView.image = cellImage;
    cell.detailTextLabel.text = detailDescription;

    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
