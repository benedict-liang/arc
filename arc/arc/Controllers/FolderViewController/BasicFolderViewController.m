//
//  BasicFolderViewController.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BasicFolderViewController.h"

NSString* const FOLDER_VIEW_FOLDERS = @"Folders";
NSString* const FOLDER_VIEW_FILES = @"Files";

@interface BasicFolderViewController ()
@property (nonatomic, strong) id<Folder> folder;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *filesAndFolders;
@end

@implementation BasicFolderViewController
@synthesize tableViewDataSource = _tableViewDataSource;
@synthesize tableViewDelegate = _tableViewDelegate;

- (id)initWithFolder:(id<Folder>)folder
{
    self = [super init];
    if (self) {
        _folder = folder;
        [self setUpFolderContents];
    }
    return self;
}

- (void)setUpFolderContents
{
    NSArray *fileObjects = (NSArray*)[_folder contents];
    
    // Temporary buckets to hold different file object types
    FileSystemObjectGroup *folders = [[FileSystemObjectGroup alloc] initWithName:FOLDER_VIEW_FOLDERS];
    FileSystemObjectGroup *files = [[FileSystemObjectGroup alloc] initWithName:FOLDER_VIEW_FILES];
    
    for (id<FileSystemObject> fileSystemObject in fileObjects) {
        if ([[fileSystemObject class] conformsToProtocol:@protocol(File)]) {
            [files addFileSystemObject:fileSystemObject];
        } else if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder) ]) {
            [folders addFileSystemObject:fileSystemObject];
        }
    }
    
    _filesAndFolders = @[folders, files];
}

- (void)setFilesAndFolders:(NSArray *)filesAndFolders
{
    _filesAndFolders = filesAndFolders;
}

- (void)setUpTableView
{
    _tableView =
    [[UITableView alloc] initWithFrame:self.view.bounds
                                 style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Pop from navigation controller hook

// Work Around to track back button action.
- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.
        // We know this is true because self is no longer
        // in the navigation stack.
        [self didPopFromNavigationController];
    }
    
    [super viewWillDisappear:animated];
}

- (void)didPopFromNavigationController
{
    
}

#pragma mark - Data Source Accessor Methods

- (NSInteger)numberOfSections
{
    return [_filesAndFolders count];
}

- (FileSystemObjectGroup *)sectionObjectGroup:(NSInteger)section
{
    return (FileSystemObjectGroup *)[_filesAndFolders objectAtIndex:section];
}

- (NSString *)sectionHeading:(NSInteger)section
{
    return [[self sectionObjectGroup:section] groupName];
}

- (NSArray *)sectionItems:(NSInteger)section
{
    return [[self sectionObjectGroup:section] items];
}

- (id<FileSystemObject>)sectionItem:(NSIndexPath *)indexPath
{
    return [[self sectionItems:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - Table view data source

// Returns the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

// Returns the number of rows in the given section.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionObjectGroup:section] length];
}

// Returns the header for the given section.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Hide section title if section has zero rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    return [self sectionHeading:section];
}

// Sets up a table cell for the given index path.
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];
    
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
    [cell resetCell];
    [cell setFileSystemObject:fileObject];
    
    // Hook for subclasses to make changes to cell before display
    [self tableView:tableView
    willPresentCell:cell
        atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willPresentCell:(FileObjectTableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Hide section title if section has zero rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    }
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FolderViewSectionHeader *sectionHeader =
    [[FolderViewSectionHeader alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 22.0)];
    
    sectionHeader.title = [self sectionHeading:section];
    
    return sectionHeader;
}

@end
