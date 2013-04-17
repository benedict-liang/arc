//
//  FolderViewController.m
//  arc
//
//  Created by Jerome Cheng on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FolderViewController.h"

@interface FolderViewController ()

@property (weak, nonatomic) id<Folder>folder;

@property NSArray *segregatedContents;

@end

@implementation FolderViewController

- (id)initWithFolder:(id<Folder>)folder
{
    if (self = [super init]) {
        _folder = folder;
    }
    return self;
}

- (void)reloadContents
{
    [self separateFilesAndFolders];
    [[self tableView] reloadData];
}

- (void)separateFilesAndFolders
{
    NSMutableArray *folders = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    NSArray *fileObjects = (NSArray*)[_folder contents];
    
    for (id<FileSystemObject> fileSystemObject in fileObjects) {
        if ([[fileSystemObject class] conformsToProtocol:@protocol(File)]) {
            [files addObject:fileSystemObject];
        } else if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder) ]) {
            [folders addObject:fileSystemObject];
        }
    }
    _segregatedContents = [NSArray arrayWithObjects:folders, files, nil];
}

- (void)loadView
{
    [super loadView];
    
    // Set up the navigation bar title.
    [[self navigationItem] setTitle:[_folder name]];
    
    // Set tableview properties.
    [[self tableView] setRowHeight:55];
    [[self tableView] setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_segregatedContents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_segregatedContents objectAtIndex:section] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // Don't display a title if the section is empty.
//    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
//        return nil;
//    }
//    // Returns the header for the given section.
//    return section == 0 ? @"Folders" : @"Files";
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    // Don't display the header if the section has no rows.
//    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
//        return 0;
//    }
//    // Return the height of the header for the given section.
//    return 22;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create a custom view for the section headers.
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 22.0)];
    [customView setBackgroundColor:[Utils colorWithHexString:@"CC272821"]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setOpaque:NO];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica Neue Bold" size:18]];
    [headerLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [headerLabel setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] ];
    [headerLabel setFrame:CGRectMake(11,-11, 320.0, 44.0)];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setText:(section == 0 ? @"Folders" : @"Files")];
    [customView addSubview:headerLabel];
    return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FileAndFolderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    
    NSArray *section = [_segregatedContents objectAtIndex:[indexPath section]];
    id<FileSystemObject> fileObject = [section objectAtIndex:[indexPath row]];
    
    NSString *detailDescription;
    UIImage *cellImage;
    if ([[fileObject class] conformsToProtocol:@protocol(File)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"file.png"]
                          toSize:CGSizeMake(35, 35)];
        detailDescription = [Utils humanReadableFileSize:[fileObject size]];
    } else if ([[fileObject class] conformsToProtocol:@protocol(Folder)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"folder.png"]
                          toSize:CGSizeMake(35, 35)];
        
        switch ((int)[fileObject size]) {
            case 0:
                detailDescription = @"Empty Folder";
                break;
            case 1:
                detailDescription = @"1 item";
            default:
                detailDescription = [NSString stringWithFormat:@"%d items", (int)[fileObject size]];
                break;
        }
    }
    
    // Cell Text Appearance
    [[cell textLabel] setText:[fileObject name]];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
    [[cell detailTextLabel] setText:detailDescription];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    
    [[cell imageView] setImage:cellImage];
    
    // Selection Appearance
    UIView *backgroundView = [[UIView alloc] init];
    [backgroundView setBackgroundColor:[Utils colorWithHexString:@"ee151512"]];
    [cell setSelectedBackgroundView:backgroundView];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check what type of object is selected.
    NSArray *section = [_segregatedContents objectAtIndex:[indexPath section]];
    id<FileSystemObject> fileObject = [section objectAtIndex:[indexPath row]];
    
    if ([fileObject conformsToProtocol:@protocol(Folder)]) {
        id<Folder> selectedFolder = (id<Folder>)fileObject;
        
        // Notify our delegate, and navigate into the folder.
        [_delegate folderViewController:self selectedFolder:selectedFolder];
        FolderViewController *newFolderViewController = [[FolderViewController alloc] initWithFolder:selectedFolder];
        [[self navigationController] pushViewController:newFolderViewController animated:YES];
    } else {
        id<File> selectedFile = (id<File>)fileObject;
        
        // Notify our delegate.
        [_delegate folderViewController:self selectedFile:selectedFile];
    }
    
}

@end
