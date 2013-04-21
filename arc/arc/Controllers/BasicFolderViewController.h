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

@interface BasicFolderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithFolder:(id<Folder>)folder;
- (void)setUpFolderContents;
- (void)setUpTableView;
- (void)didPopFromNavigationController;

// TableView Delegate and Datasource
@property (nonatomic, strong) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) id<UITableViewDataSource> tableViewDataSource;

// Data source Accessor Methods
- (NSDictionary *)sectionDictionary:(NSInteger)section;
- (NSString *)sectionHeading:(NSInteger)section;
- (NSMutableArray *)sectionItems:(NSInteger)section;
- (id<FileSystemObject>)sectionItem:(NSIndexPath *)indexPath;

@end
