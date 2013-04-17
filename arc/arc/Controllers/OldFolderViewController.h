//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "SubViewControllerDelegate.h"
#import "OldFolderViewControllerDelegate.h"
#import "CreateFolderViewController.h"
#import "CreateFolderViewControllerDelegate.h"

// Cloud Imports
#import "CloudPickerViewController.h"
#import "CloudPickerViewControllerDelegate.h"
#import "SkyDriveFolder.h"
#import "GoogleDriveFolder.h"
#import "SkyDriveServiceManager.h"
#import "GoogleDriveServiceManager.h"

@interface OldFolderViewController : UIViewController <SubViewControllerDelegate,
    UITableViewDelegate, UITableViewDataSource, CreateFolderViewControllerDelegate, UIActionSheetDelegate, CloudPickerViewControllerDelegate>
@property (nonatomic, readonly) id<Folder> folder;
@property (nonatomic, weak) id<OldFolderViewControllerDelegate> folderViewControllerDelegate;
- (id)initWithFolder:(id<Folder>)folder;
- (void)triggerAddItem;
- (void)refreshFolderContents;
- (void)editActionTriggeredAnimate:(BOOL)animate;
@end
