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

- (void)folderViewController:(FolderViewController *)sender selectedFile:(id<File>)file;

- (void)folderViewController:(FolderViewController *)sender selectedFolder:(id<Folder>)folder;

@end
