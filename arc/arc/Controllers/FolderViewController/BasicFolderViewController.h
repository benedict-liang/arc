//
//  BasicFolderViewController.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "Folder.h"
#import "FileObjectTableViewCell.h"
#import "FolderViewSectionHeader.h"
#import "FileSystemObjectGroup.h"

@interface BasicFolderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithFolder:(id<Folder>)folder;
- (void)setUpFolderContents;
- (void)setUpTableView;
- (void)didPopFromNavigationController;
- (void)refreshFolderView;

@property (nonatomic, readonly) id<Folder> folder;
@property (nonatomic, readonly) UITableView *tableView;

// TableView Delegate and Datasource
@property (nonatomic, strong) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) id<UITableViewDataSource> tableViewDataSource;

- (void)tableView:(UITableView *)tableView
  willPresentCell:(FileObjectTableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath;

// Data source Accessor Methods
- (void)setFilesAndFolders:(NSArray *)filesAndFolders;
- (NSInteger)numberOfSections;
- (FileSystemObjectGroup *)sectionObjectGroup:(NSInteger)section;
- (NSString *)sectionHeading:(NSInteger)section;
- (NSArray *)sectionItems:(NSInteger)section;
- (id<FileSystemObject>)sectionItem:(NSIndexPath *)indexPath;

// Constants
extern NSString* const FOLDER_VIEW_FOLDERS;
extern NSString* const FOLDER_VIEW_FILES;
@end
