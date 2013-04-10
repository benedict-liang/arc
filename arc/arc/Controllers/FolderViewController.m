//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FolderViewController.h"
#import "Utils.h"
#import "RootFolder.h"
#import "File.h"
#import "Folder.h"

@interface FolderViewController ()
@property id<Folder> folder;
@property UITableView *tableView;
@property NSArray *filesAndFolders;

@property CreateFolderViewController *createFolderController;
@property UIPopoverController *addFolderPopoverController;

@property UIBarButtonItem *addFolderButton;
@end

@implementation FolderViewController
@synthesize delegate = _delegate;

- (id)initWithFolder:(id<Folder>)folder
{
    self = [super init];
    if (self) {
        _folder = folder;
        [self sortFilesAndFolders];
    }
    return self;
}

- (void)sortFilesAndFolders
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
    _filesAndFolders = [NSArray arrayWithObjects:folders, files, nil];
}

- (void)refreshFolderContents
{
    [self sortFilesAndFolders];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _addFolderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(triggerAddFolder)];
    
    // Set up the navigation bar.
    self.title = _folder.name;
    
    // Add the "add folder" button. (TEMP - move as needed to improve UX.)
    NSMutableArray *rightButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [rightButtonItems addObject:_addFolderButton];
    self.navigationItem.rightBarButtonItems = rightButtonItems;

    self.view.autoresizesSubviews = YES;

    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;

    // TableView Row Height
    _tableView.rowHeight = 60;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    _createFolderController = [[CreateFolderViewController alloc] init];
    [_createFolderController setFolder:_folder];
//    [_createFolderController.tableView reloadData];
}

// Work Around to track back button action.
- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.
        // We know this is true because self is no longer
        // in the navigation stack.
        [self.delegate fileObjectSelected:[_folder parent]];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

// Returns the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_filesAndFolders count];
}

// Returns the number of rows in the given section.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[_filesAndFolders objectAtIndex:section] count];
}

// Returns the header for the given section.
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    // Hide section title if section has zero rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }

    if (section == 0) {
        return @"Folders";
    } else {
        return @"Files";
    }
}

// Sets up a table cell for the given index path.
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"FileAndFolderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    
    NSArray *section = [_filesAndFolders objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [section objectAtIndex:indexPath.row];
    
    NSString *detailDescription;
    UIImage *cellImage;
    if ([[fileObject class] conformsToProtocol:@protocol(File)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"file.png"]
                                     toSize:CGSizeMake(40, 40)];
        detailDescription = [NSString stringWithFormat:
                             @"%@", [Utils humanReadableFileSize:fileObject.size]];
    } else if ([[fileObject class] conformsToProtocol:@protocol(Folder)]) {
        cellImage = [Utils scale:[UIImage imageNamed:@"folder.png"]
                                     toSize:CGSizeMake(40, 40)];
        detailDescription = [NSString stringWithFormat:@"%d objects", fileObject.size];
    }

    cell.textLabel.text = fileObject.name;
    cell.imageView.image = cellImage;
    cell.detailTextLabel.text = detailDescription;

    return cell;
}

// Determines if the cell at the given index path can be edited.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currentSection = [_filesAndFolders objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [currentSection objectAtIndex:indexPath.row];
    
    return [fileObject isRemovable];
}

#pragma mark - Table view delegate

// Triggered when the cell at the given index path is selected.
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *section = [_filesAndFolders objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [section objectAtIndex:indexPath.row];
    [self.delegate fileObjectSelected:fileObject];
    
    // unhighlight TableViewCell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Editing-related methods
- (void)toggleEdit:(id)sender
{
    BOOL shouldTableEdit = !_tableView.editing;
    [_tableView setEditing:shouldTableEdit animated:YES];
}

// Triggers when the user confirms an edit operation on the cell at the given index path.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *currentSection = [_filesAndFolders objectAtIndex:indexPath.section];
        id<FileSystemObject> fileObject = [currentSection objectAtIndex:indexPath.row];
        
        if ([fileObject remove]) {
            [(NSMutableArray *)[_filesAndFolders objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

// Triggers when the user clicks the Add button.
- (void)triggerAddFolder
{
    if (!_addFolderPopoverController) {
        _addFolderPopoverController = [[UIPopoverController alloc] initWithContentViewController:_createFolderController];
    }
    
    // Toggle the visibility of the popover controller.
    if (![_addFolderPopoverController isPopoverVisible]) {
        [_addFolderPopoverController presentPopoverFromBarButtonItem:_addFolderButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [_addFolderPopoverController dismissPopoverAnimated:YES];
    }
}

@end
