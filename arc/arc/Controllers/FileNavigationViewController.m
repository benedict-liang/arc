//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileNavigationViewController.h"
#import "Utils.h"
#import "RootFolder.h"
#import "File.h"
#import "Folder.h"

@interface FileNavigationViewController ()
@property id<Folder> currentFolder;
@property UITableView *tableView;
@property NSArray *filesAndFolders;
@end

@implementation FileNavigationViewController
@synthesize delegate;
@synthesize tableView = _tableView;
@synthesize currentFolder = _currentFolder;
@synthesize filesAndFolders = _filesAndFolders;

- (id)init
{
    self = [super init];
    if (self) {
        // tmp.
        _currentFolder = [RootFolder sharedRootFolder];
        
        NSMutableArray *folders = [NSMutableArray array];
        NSMutableArray *files = [NSMutableArray array];
        NSArray *folderContents = (NSArray*)[_currentFolder contents];

        for (id<FileSystemObject> fileObject in folderContents) {
            if ([[fileObject class] conformsToProtocol:@protocol(File)]) {
                [files addObject:fileObject];
            } else if ([[fileObject class] conformsToProtocol:@protocol(Folder) ]) {
                [folders addObject:fileObject];
            }
        }
        
        _filesAndFolders = [NSArray arrayWithObjects:
                            folders,
                            files,
                            nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)showFolder:(id<Folder>)folder
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_filesAndFolders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_filesAndFolders objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Folders";
    } else {
        return @"Files";
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
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
}

@end
