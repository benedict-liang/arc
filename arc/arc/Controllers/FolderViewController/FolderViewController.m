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
@property CreateFolderViewController *createFolderController;
@property UIPopoverController *addFolderPopoverController;
@property UIBarButtonItem *addItemButton;
@property UIActionSheet *addItemActionSheet;
@property NSIndexPath *currentFile;
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
        _currentFile = indexPath;
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
    }
}


#pragma mark - Edit Related methods

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self sectionItem:indexPath] isRemovable];
}

- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated
{
    [self.tableView setAllowsMultipleSelectionDuringEditing:editing];
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];

    _editSelection = [NSMutableArray array];

    if (editing) {
        [self.folderViewControllerDelegate folderViewController:self
                                        DidEnterEditModeAnimate:YES];
    } else {
        [self.folderViewControllerDelegate folderViewController:self
                                         DidExitEditModeAnimate:YES];
        [self.tableView reloadRowsAtIndexPaths:@[_currentFile]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)editActionTriggeredAnimate:(BOOL)animate
{
    if ([_editSelection count] > 0) {
        if ([_editSelection count] == 1) {
            _deleteButton.title = @"Delete Item";
            _moveButton.title = @"Move Item";
        } else {
            _deleteButton.title = @"Delete Items";
            _moveButton.title = @"Move Items";
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
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _editToolbar.frame = endState;
        }];   
    }
}

- (void)hideEditToolbarAnimate:(BOOL)animate
{
    CGRect endState = CGRectMake(0, self.view.frame.size.height,
                                 self.view.frame.size.width, 44);
    if (!animate) {
        _editToolbar.frame = endState;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _editToolbar.frame = endState;
        }];
    }
}

- (void)deleteItems:(id)sender
{
    for (NSIndexPath *indexPath in _editSelection) {
        [[self sectionItem:indexPath] remove];
    }
    [self setUpFolderContents];
    [self.tableView deleteRowsAtIndexPaths:_editSelection
                          withRowAnimation:UITableViewRowAnimationAutomatic];

    _editSelection = [NSMutableArray array];
}

- (void)moveItems:(id)sender
{
    DestinationFolderViewController *moveDestinationFolderViewController =
    [[DestinationFolderViewController alloc] initWithFolder:[RootFolder sharedRootFolder]];
    
    moveDestinationFolderViewController.delegate = self;

    [self showModalViewController:moveDestinationFolderViewController];
}

#pragma mark - Single Cell Delete (Swipe)

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<FileSystemObject> fileObject = [self sectionItem:indexPath];
        if ([fileObject remove]) {
            [[self sectionObjectGroup:indexPath.section]
             removeFileSystemObject:[self sectionItem:indexPath]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> fileObject = [self sectionItem:indexPath];
    if ([[fileObject identifier] isEqualToString:[[[self delegate] currentfile] identifier]]) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionMiddle];
    }
}


// MultiView target
- (void)secondFileSelected:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        FileObjectTableViewCell *cell = (FileObjectTableViewCell *)gesture.view;
        [self.delegate secondFileObjectSelected:cell.fileSystemObject];
    }
}

// Triggers when the user taps the Add button.
- (void)triggerAddItem:(id)sender
{
    // Hide the add folder popover.
    if ([_addFolderPopoverController isPopoverVisible]) {
        [_addFolderPopoverController dismissPopoverAnimated:YES];
        return;
    }

    if ([_addItemActionSheet isVisible]) {
        [_addItemActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    } else {
        if ([self.folder isKindOfClass:[DropBoxFolder class]]) {
            _addItemActionSheet =
            [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"New Folder", nil];
        } else {
            _addItemActionSheet =
            [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"New Folder", @"File from SkyDrive", @"File from Google Drive", nil];
        }

        [_addItemActionSheet showFromBarButtonItem:_addItemButton
                                          animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![self.folder isKindOfClass:[DropBoxFolder class]]) {
        switch (buttonIndex) {
            case 0:
                [self showAddFolderModal];
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
                    [self showModalViewController:pickerController];
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
                    [self showModalViewController:pickerController];

                }
                break;

            default:
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self showAddFolderModal];
                break;

            default:
                break;
        }
    }
}

- (void)showAddFolderModal
{
    AddFolderViewController *addFolderViewController =
    [[AddFolderViewController alloc] init];

    addFolderViewController.delegate = self;
    
    [self showModalViewController:addFolderViewController];
}

- (void)showModalViewController:(UIViewController *)viewController
{
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (void)createFolderWithName:(NSString *)name
{
    [self.folder createFolderWithName:name];
    [self refreshFolderView];
    [_addFolderPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - presenting modal view controller delegate

- (void)modalViewControllerDone:(FolderCommandObject *)folderCommandObject
{
    if (folderCommandObject.type == kMoveFileObjects) {
        if ([[folderCommandObject.target class] conformsToProtocol:@protocol(Folder)]) {
            id<Folder> destination = (id<Folder>)folderCommandObject.target;
            
            if (![[destination identifier] isEqualToString:[self.folder identifier]]) {
                for (NSIndexPath *indexPath in _editSelection) {
                    [destination takeFileSystemObject:[self sectionItem:indexPath]];
                }
                
                [self setUpFolderContents];
                [self.tableView deleteRowsAtIndexPaths:_editSelection
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self setEditing:NO animated:YES];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else if (folderCommandObject.type == kCancelCommand) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
         [self dismissViewControllerAnimated:YES completion:^{
             [self refreshFolderView];
         }];
    }
}

- (NSArray *)editSelection
{
    NSMutableArray *fileObjectsSelected = [NSMutableArray array];
    for (NSIndexPath *indexPath in _editSelection) {
        [fileObjectsSelected addObject:[self sectionItem:indexPath]];
    }
    return [NSArray arrayWithArray:fileObjectsSelected];
}

@end
