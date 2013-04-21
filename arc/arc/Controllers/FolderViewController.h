//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerDelegate.h"
#import "BasicFolderViewController.h"

#import "FolderViewControllerDelegate.h"
#import "CreateFolderViewController.h"
#import "CreateFolderViewControllerDelegate.h"
#import "DestinationFolderViewController.h"
#import "PresentingModalViewControllerDelegate.h"
#import "DropBoxFolder.h"

// Cloud Imports
#import "CloudPickerViewController.h"
#import "SkyDriveFolder.h"
#import "GoogleDriveFolder.h"
#import "SkyDriveServiceManager.h"
#import "GoogleDriveServiceManager.h"

@interface FolderViewController : BasicFolderViewController <SubViewControllerDelegate,
    UITableViewDelegate, UITableViewDataSource, CreateFolderViewControllerDelegate,
    UIActionSheetDelegate, PresentingModalViewControllerDelegate>
@property (nonatomic, weak) id<FolderViewControllerDelegate> folderViewControllerDelegate;
- (void)refreshFolderView;
- (void)editActionTriggeredAnimate:(BOOL)animate;
@end
