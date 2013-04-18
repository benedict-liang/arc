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

// Edit-related Items
@property NSMutableArray *editSelectedItems;
@property UIToolbar *editToolbar;
@property UIBarButtonItem *deleteButton;
@property UIBarButtonItem *moveButton;

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
    
    // If we're allowed to edit, show the edit button.
    if (_isEditAllowed) {
        [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
        
        // Create the delete and move buttons.
        _deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                         style:UIBarButtonItemStyleBordered target:self
                                                        action:@selector(deleteItems:)];
        _moveButton = [[UIBarButtonItem alloc] initWithTitle:@"Move"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(moveItems:)];
        
        // Create the edit toolbar.
        _editToolbar = [[UIToolbar alloc] init];
        [_editToolbar setFrame:CGRectMake(0, self.view.frame.size.height,
                                        self.view.frame.size.width, 44)];
        [_editToolbar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_editToolbar setItems:[NSArray arrayWithObjects:
                                [Utils flexibleSpace],
                                _deleteButton,
                                _moveButton,
                                [Utils flexibleSpace],
                                nil]];
        [[self view] addSubview:_editToolbar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContents];
}

// Work Around to track back button action.
- (void)viewWillDisappear:(BOOL)animated
{
    if ([[[self navigationController] viewControllers] indexOfObject:self] == NSNotFound) {
        // back button was pressed.
        // We know this is true because self is no longer
        // in the navigation stack.
        [_delegate folderViewController:self selectedFolder:(id<Folder>)[_folder parent]];
    }
    
    [super viewWillDisappear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Don't display the header if the section has no rows.
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    }
    // Return the height of the header for the given section.
    return 22;
}

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
    
//    if ([[fileObject path] isEqualToString:[[_delegate currentFile] path]]) {
//        [tableView selectRowAtIndexPath:indexPath
//                               animated:YES
//                         scrollPosition:UITableViewScrollPositionMiddle];
//    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check what type of object is selected.
    NSArray *section = [_segregatedContents objectAtIndex:[indexPath section]];
    id<FileSystemObject> fileObject = [section objectAtIndex:[indexPath row]];
    
    if ([[self tableView] isEditing]) {
        // We're in edit mode. Add the selected index path to the array.
        [_editSelectedItems addObject:indexPath];
        [self itemTappedInEditModeAnimate:YES];
    } else if ([fileObject conformsToProtocol:@protocol(Folder)]) {
        id<Folder> selectedFolder = (id<Folder>)fileObject;
        
        // Notify our delegate, and navigate into the folder.
        [_delegate folderViewController:self selectedFolder:selectedFolder];
        FolderViewController *newFolderViewController = [[FolderViewController alloc] initWithFolder:selectedFolder];
        [newFolderViewController setDelegate:_delegate];
        [newFolderViewController setIsEditAllowed:_isEditAllowed];
        [[self navigationController] pushViewController:newFolderViewController animated:YES];
    } else {
        id<File> selectedFile = (id<File>)fileObject;
        
        // Notify our delegate.
        [_delegate folderViewController:self selectedFile:selectedFile];
    }
    
}

#pragma mark - Editing-related methods

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEditing]) {
        [_editSelectedItems removeObject:indexPath];
        [self itemTappedInEditModeAnimate:YES];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [[self tableView] setAllowsMultipleSelectionDuringEditing:editing];
    [super setEditing:editing animated:animated];
    _editSelectedItems = [NSMutableArray array];
    if (editing) {
        [_delegate folderViewController:self DidEnterEditModeAnimate:animated];
    } else {
        [_delegate folderViewController:self DidExitEditModeAnimate:animated];
        [self hideEditToolbarAnimate:animated];
    }
}

- (void)itemTappedInEditModeAnimate:(BOOL)animate
{
    int numberOfSelectedItems = [_editSelectedItems count];

    if (numberOfSelectedItems == 0) {
        [self hideEditToolbarAnimate:animate];
    } else {
        [self showEditToolbarAnimate:animate];
    }
}

- (void)showEditToolbarAnimate:(BOOL)animate
{
    CGRect endState = CGRectMake(0, self.view.frame.size.height - 44,
                                 self.view.frame.size.width, 44);
    if (!animate) {
        _editToolbar.frame = endState;
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [_editToolbar setFrame:endState];
    [UIView commitAnimations];
}

- (void)hideEditToolbarAnimate:(BOOL)animate
{
    CGRect endState = CGRectMake(0, self.view.frame.size.height,
                                 self.view.frame.size.width, 44);
    if (!animate) {
        _editToolbar.frame = endState;
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [_editToolbar setFrame:endState];
    [UIView commitAnimations];
}

- (void)deleteItems:(id)sender
{
    for (NSIndexPath *indexPath in _editSelectedItems) {
        NSArray *currentSection = [_segregatedContents objectAtIndex:indexPath.section];
        id<FileSystemObject> fileSystemObject = [currentSection objectAtIndex:indexPath.row];
        [fileSystemObject remove];
    }
    
    [self separateFilesAndFolders];
    [[self tableView] deleteRowsAtIndexPaths:_editSelectedItems
                      withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)moveItems:(id)sender
{
    // TODO.
    NSLog(@"%@", _editSelectedItems);
}

// Triggers when the user confirms an edit operation on the cell at the given index path.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *currentSection = [_segregatedContents objectAtIndex:indexPath.section];
        id<FileSystemObject> fileObject = [currentSection objectAtIndex:indexPath.row];
        
        if ([fileObject remove]) {
            [(NSMutableArray *)[_segregatedContents objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

// Determines if the cell at the given index path can be edited.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currentSection = [_segregatedContents objectAtIndex:indexPath.section];
    id<FileSystemObject> fileObject = [currentSection objectAtIndex:indexPath.row];
    
    return [fileObject isRemovable];
}

@end
