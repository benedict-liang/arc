//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define SECTION_HEADING @"section heading"
#define SECTION_ITEMS @"section items"
#define FOLDER @"Folders"
#define FILES @"Files"

#import "FolderViewController.h"
#import "FolderViewSectionHeader.h"
#import "RootFolder.h"
#import "File.h"
#import "Folder.h"

@interface FolderViewController ()
@property id<Folder> folder;
@property UITableView *tableView;
@property NSArray *filesAndFolders;

// Edit Related Stuff
@property NSMutableArray *editSelection;

@property UIToolbar *editToolbar;
@property UIBarButtonItem *deleteButton;
@property UIBarButtonItem *moveButton;
- (void)editMode;
- (void)normalMode;

@property CreateFolderViewController *createFolderController;
@property UIPopoverController *addFolderPopoverController;
@property UIBarButtonItem *addItemButton;
@property UIActionSheet *addItemActionSheet;

// Cloud Controllers
@property SkyDriveServiceManager *skyDriveManager;
@property GoogleDriveServiceManager *googleDriveManager;
@end

@implementation FolderViewController
@synthesize delegate = _delegate;
@synthesize folderViewControllerDelegate = _folderViewControllerDelegate;

- (id)initWithFolder:(id<Folder>)folder
{
    self = [super init];
    if (self) {
        _folder = folder;
        [self setUpCloudControllers];
        [self setUpFilesAndFolders];
    }
    return self;
}

- (void)setUpCloudControllers
{
    _skyDriveManager =
    (SkyDriveServiceManager *)[SkyDriveServiceManager sharedServiceManager];
    
    _googleDriveManager =
    (GoogleDriveServiceManager *)[GoogleDriveServiceManager sharedServiceManager];
}


- (void)setUpFilesAndFolders
{
    NSArray *fileObjects = (NSArray*)[_folder contents];
    
    // Temporary buckets to hold different file object types
    NSMutableArray *folders = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    
    for (id<FileSystemObject> fileSystemObject in fileObjects) {
        if ([[fileSystemObject class] conformsToProtocol:@protocol(File)]) {
            [files addObject:fileSystemObject];
        } else if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder) ]) {
            [folders addObject:fileSystemObject];
        }
    }

    _filesAndFolders = @[
                         @{
                             SECTION_HEADING: FOLDER,
                             SECTION_ITEMS: folders
                             },
                         @{
                             SECTION_HEADING: FILES,
                             SECTION_ITEMS: files
                             }
                         ];
}

- (void)refreshFolderView
{
    [self setUpFilesAndFolders];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _addItemButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(triggerAddItem)];

    // Create the add folder controller and its popover.
    _createFolderController =
    [[CreateFolderViewController alloc] initWithDelegate:self];
    
    _addFolderPopoverController =
    [[UIPopoverController alloc] initWithContentViewController:_createFolderController];
    
    // Set up the navigation bar.
    self.title = _folder.name;
    
    // Add the "edit" and "add folder" buttons.
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:self.editButtonItem, _addItemButton, nil];

    self.view.autoresizesSubviews = YES;

    // Set Up TableView
    _tableView =
    [[UITableView alloc] initWithFrame:self.view.bounds
                                 style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    // Create the add folder controller.
    _createFolderController =
    [[CreateFolderViewController alloc] initWithDelegate:self];
    
    _editToolbar = [[UIToolbar alloc] init];
    _editToolbar.frame = CGRectMake(0, self.view.frame.size.height,
                                    self.view.frame.size.width, 44);
    _editToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    _deleteButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Delete Item"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(deleteItems:)];
    _moveButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Move Item"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(moveItems:)];
    
    _editToolbar.items = [NSArray arrayWithObjects:
                          [Utils flexibleSpace],
                          _deleteButton,
                          _moveButton,
                          [Utils flexibleSpace],
                          nil];

    [self.view addSubview:_editToolbar];
}

// Work Around to track back button action.
// track back button to persist current folder
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

#pragma mark - Utils

- (NSDictionary *)sectionDictionary:(NSInteger)section
{
    return (NSDictionary *)[_filesAndFolders objectAtIndex:section];
}

- (NSString *)sectionHeading:(NSInteger)section
{
    return [[self sectionDictionary:section] objectForKey:SECTION_HEADING];
}

- (NSMutableArray *)sectionItems:(NSInteger)section
{
    return (NSMutableArray *)[[self sectionDictionary:section]
                              objectForKey:SECTION_ITEMS];
}

- (id<FileSystemObject>)sectionItem:(NSIndexPath *)indexPath
{
    return [[self sectionItems:indexPath.section] objectAtIndex:indexPath.row];
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
    return [[self sectionItems:section] count];
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
    
    [cell setFileSystemObject:fileObject];
    
    if ([[fileObject identifier] isEqualToString:[[[self delegate] currentfile] identifier]]) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionMiddle];
    }

    // Remove Gesture Recoginzers
    [Utils removeAllGestureRecognizersFrom:cell];

    // Long Press Gesture for splitcodeview
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(secondFileSelected:)];
    [cell addGestureRecognizer:longPressGesture];

    return cell;
}

- (void)secondFileSelected:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        FileObjectTableViewCell *cell = (FileObjectTableViewCell *)gesture.view;
        [self.delegate secondFileObjectSelected:cell.fileSystemObject];
    }
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

// Determines if the cell at the given index path can be edited.
- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];
    
    return [fileObject isRemovable];
}

#pragma mark - Table view delegate

// Triggered when the cell at the given index path is selected.
- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];

    if (tableView.editing) {
        // Editing mode
        [_editSelection addObject:indexPath];
        [self editActionTriggeredAnimate:YES];
        return;
    } else {
        // Normal mode
        [self.delegate fileObjectSelected:fileObject];
    }
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        // Editing mode
        [_editSelection removeObject:indexPath];
        [self editActionTriggeredAnimate:YES];
        return;
    } else {
        // Normal Mode
        // Do nothing.
    }
}

#pragma mark - Edit Related methods
- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated
{
    _tableView.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
    if (editing) {
        [self editMode];
    } else {
        [self normalMode];
    }
}

- (void)editMode
{
    _editSelection = [NSMutableArray array];
    [self.folderViewControllerDelegate folderViewController:self
                                    DidEnterEditModeAnimate:YES];
}

- (void)normalMode
{
    _editSelection = [NSMutableArray array];
    [self.folderViewControllerDelegate folderViewController:self
                                    DidExitEditModeAnimate:YES];
}

- (void)editActionTriggeredAnimate:(BOOL)animate
{
    int count = [_editSelection count];
    if (count > 0) {
        if (count > 1) {
            _deleteButton.title = @"Delete Items";
            _moveButton.title = @"Move Items";
        } else {
            _deleteButton.title = @"Delete Item";
            _moveButton.title = @"Move Item";
        }
        
        [self showEditToolbarAnimate:animate];
    } else {
        [self hideEditToolbarAnimate:animate];
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
    _editToolbar.frame = endState;
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
    _editToolbar.frame = endState;
    [UIView commitAnimations];
}

- (void)deleteItems:(id)sender
{
    for (NSIndexPath *indexPath in _editSelection) {
        id<FileSystemObject> fileObject = [self sectionItem:indexPath];
        [fileObject remove];
    }

    [self setUpFilesAndFolders];

    [_tableView deleteRowsAtIndexPaths:_editSelection
                      withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)moveItems:(id)sender
{
    // TODO.
    NSLog(@"%@", _editSelection);
}

// Triggers when the user confirms an edit operation on the cell at the given index path.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<FileSystemObject> fileObject = [self sectionItem:indexPath];

        if ([fileObject remove]) {
            [[self sectionItems:indexPath.section] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

// Triggers when the user clicks the Add button.
- (void)triggerAddItem
{
    // Hide the add folder popover.
    if ([_addFolderPopoverController isPopoverVisible]) {
        [_addFolderPopoverController dismissPopoverAnimated:YES];
    }

    if ([_addItemActionSheet isVisible]) {
        [_addItemActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }

    else {
        if ([_folder isKindOfClass:[DropBoxFolder class]]) {
            _addItemActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"New Folder", nil];
        } else {
            _addItemActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"New Folder", @"File from SkyDrive", @"File from Google Drive", nil];
        }
        
        [_addItemActionSheet showFromBarButtonItem:_addItemButton animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![_folder isKindOfClass:[DropBoxFolder class]]) {
        switch (buttonIndex) {
            case 0:
                [_addFolderPopoverController presentPopoverFromBarButtonItem:_addItemButton
                                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                    animated:YES];
                break;

            case 1:
                if (![_skyDriveManager isLoggedIn]) {
                    [_skyDriveManager loginWithViewController:self];
                } else {
                    CloudPickerViewController *pickerController =
                    [[CloudPickerViewController alloc] initWithCloudFolder:[SkyDriveFolder getRoot]
                                                              targetFolder:_folder
                                                            serviceManager:_skyDriveManager];
                    [pickerController setDelegate:self];

                    UINavigationController *navController =
                    [[UINavigationController alloc] initWithRootViewController:pickerController];

                    [navController setModalPresentationStyle:UIModalPresentationFormSheet];

                    [self presentViewController:navController
                                       animated:YES
                                     completion:nil];
                }
                break;

            case 2:
                if (![_googleDriveManager isLoggedIn]) {
                    [_googleDriveManager loginWithViewController:self];
                } else {
                    CloudPickerViewController *pickerController =
                    [[CloudPickerViewController alloc] initWithCloudFolder:[GoogleDriveFolder getRoot]
                                                              targetFolder:_folder
                                                            serviceManager:_googleDriveManager];

                    [pickerController setDelegate:self];
                    
                    UINavigationController *navController =
                    [[UINavigationController alloc] initWithRootViewController:pickerController];
                    
                    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
                    
                    [self presentViewController:navController
                                       animated:YES
                                     completion:nil];
                }
                break;

            default:
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [_addFolderPopoverController presentPopoverFromBarButtonItem:_addItemButton
                                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                    animated:YES];
                break;

            default:
                break;
        }
    }
}

- (void)cloudPickerDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^ {
        [self refreshFolderView];
    }];
}

- (void)createFolderWithName:(NSString *)name
{
    [_folder createFolderWithName:name];
    [self refreshFolderView];
    
    [_addFolderPopoverController dismissPopoverAnimated:YES];
}

- (void)downloadedFileFromPicker:(id)sender
{
    
}
@end
