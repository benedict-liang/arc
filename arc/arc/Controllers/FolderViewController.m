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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hooks into UINavigationViewController
    self.title = _folder.name;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_filesAndFolders count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[_filesAndFolders objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Folders";
    } else {
        return @"Files";
    }
}

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
    
    if ([[fileObject class] conformsToProtocol:@protocol(File)]) {
        id<File> file = (id<File>) fileObject;
        cell.imageView.image = [Utils scale:[UIImage imageNamed:@"file.png"]
                                     toSize:CGSizeMake(40, 40)];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ file", file.extension];
    } else if ([[fileObject class] conformsToProtocol:@protocol(Folder)]) {
        cell.imageView.image = [Utils scale:[UIImage imageNamed:@"folder.png"]
                                     toSize:CGSizeMake(40, 40)];
        cell.detailTextLabel.text = @"Folder";
    }

    cell.textLabel.text = fileObject.name;    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *section = [_filesAndFolders objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [section objectAtIndex:indexPath.row];
    [self.delegate fileObjectSelected:fileObject];
    
    // unhighlight TableViewCell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
