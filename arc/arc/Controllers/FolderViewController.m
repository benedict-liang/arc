//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FolderViewController.h"

@interface FolderViewController ()
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
    self = [super initWithFolder:folder];
    if (self) {
        [self setUpCloudControllers];
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

- (void)refreshFolderView
{
    [self setUpFolderContents];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _addItemButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(triggerAddItem:)];

    // Create the add folder controller and its popover.
    _createFolderController =
    [[CreateFolderViewController alloc] initWithDelegate:self];
    
    _addFolderPopoverController =
    [[UIPopoverController alloc] initWithContentViewController:_createFolderController];
    
    // Set up the navigation bar.
    self.title = self.folder.name;
    
    // Add the "edit" and "add folder" buttons.
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:self.editButtonItem, _addItemButton, nil];

    self.view.autoresizesSubviews = YES;
    
    [self setUpTableView];
    
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

- (void)didPopFromNavigationController
{
    [self.delegate fileObjectSelected:[self.folder parent]];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView
  willPresentCell:(FileObjectTableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];
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

// Determines if the cell at the given index path can be edited.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];
    
    return [fileObject isRemovable];
}

- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated
{
    self.tableView.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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

    [self setUpFolderContents];

    [self.tableView deleteRowsAtIndexPaths:_editSelection
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


#pragma mark - targets

- (void)secondFileSelected:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        FileObjectTableViewCell *cell = (FileObjectTableViewCell *)gesture.view;
        [self.delegate secondFileObjectSelected:cell.fileSystemObject];
    }
}

// Triggers when the user clicks the Add button.
- (void)triggerAddItem:(id)sender
{
    // Hide the add folder popover.
    if ([_addFolderPopoverController isPopoverVisible]) {
        [_addFolderPopoverController dismissPopoverAnimated:YES];
    }

    if ([_addItemActionSheet isVisible]) {
        [_addItemActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }

    else {
        if ([self.folder isKindOfClass:[DropBoxFolder class]]) {
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
    if (![self.folder isKindOfClass:[DropBoxFolder class]]) {
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
                                                              targetFolder:self.folder
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
                                                              targetFolder:self.folder
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
    [self.folder createFolderWithName:name];
    [self refreshFolderView];
    
    [_addFolderPopoverController dismissPopoverAnimated:YES];
}

- (void)downloadedFileFromPicker:(id)sender
{
    
}
@end
