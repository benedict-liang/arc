//
//  DestinationFolderViewController.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DestinationFolderViewController.h"

@interface DestinationFolderViewController ()
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@end

@implementation DestinationFolderViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [self setUpTableView];
    [self setUpNavigationController];
    self.title = self.folder.name;

    _closeButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(shouldClose:)];
    self.navigationItem.rightBarButtonItem = _closeButton;
}

- (void)setUpNavigationController
{
    self.navigationController.toolbarHidden = NO;
    
    UILabel *label =
    [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Choose a destination.";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.frame = CGRectMake(10,
                             floorf((self.navigationController.toolbar.bounds.size.height - label.frame.size.height)/2),
                             label.frame.size.width,
                             label.frame.size.height);
    
    [self.navigationController.toolbar addSubview:label];
    
    
    UIBarButtonItem *createFolderButton =
    [[UIBarButtonItem alloc] initWithTitle:@"New Folder"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(newFolder:)];
    UIBarButtonItem *selectFolderButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Select Folder"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(selectFolder:)];
    
    self.toolbarItems = @[
                          [Utils flexibleSpace],
                          createFolderButton,
                          selectFolderButton
                          ];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<FileSystemObject> fileSystemObject = [self sectionItem:indexPath];
    
    for (id<FileSystemObject> objectToMove in [self.delegate editSelection]) {
        if ([[objectToMove identifier] isEqualToString:[fileSystemObject identifier]]) {
            // Do nothing.
            return;
        }
    }
    
    if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        
        DestinationFolderViewController *destinationFolderViewController =
        [[DestinationFolderViewController alloc] initWithFolder:(id<Folder>)fileSystemObject];
        
        destinationFolderViewController.delegate = self.delegate;

        [self.navigationController pushViewController:destinationFolderViewController
                                             animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Only folders should be selectable
- (void)tableView:(UITableView *)tableView
  willPresentCell:(FileObjectTableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
{
    if (![[cell.fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return;
    }
    
    if ([[cell.fileSystemObject identifier] isEqualToString:[self.delegate.folder identifier]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id<FileSystemObject> cellFileSystemObject = cell.fileSystemObject;
    for (id<FileSystemObject> objectToMove in [self.delegate editSelection]) {
        if ([[objectToMove identifier] isEqualToString:[cellFileSystemObject identifier]]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return;
        }
    }
}

- (void)newFolder:(id)sender
{
    // TODO.
}

- (void)selectFolder:(id)sender
{
    [self.delegate modalViewControllerDone:
     [FolderCommandObject commandOfType:kMoveFileObjects
                             withTarget:self.folder]];
}

- (void)shouldClose:(id)sender
{
    [self.delegate modalViewControllerDone:nil];
}

@end
