//
//  FolderViewControllerDelegate.h
//  arc
//
//  Created by Jerome Cheng on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "Folder.h"

@class FolderViewController;

@protocol FolderViewControllerDelegate <NSObject>

// Allows delegate to know which file or folder was selected in navigation mode.
- (void)folderViewController:(FolderViewController *)sender selectedFile:(id<File>)file;
- (void)folderViewController:(FolderViewController *)sender selectedFolder:(id<Folder>)folder;

// Allows the delegate to know if the controller has entered or left editing mode.
- (void)folderViewController:(FolderViewController *)folderViewController
     DidEnterEditModeAnimate:(BOOL)animate;
- (void)folderViewController:(FolderViewController *)folderViewController DidExitEditModeAnimate:(BOOL)animate;

@end
