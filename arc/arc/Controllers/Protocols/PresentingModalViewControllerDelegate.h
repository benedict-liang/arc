//
//  CloudPickerViewControllerDelegate.h
//  arc
//
//  Created by Jerome Cheng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"
#import "FolderCommandObject.h"

@protocol PresentingModalViewControllerDelegate <NSObject>
- (void)modalViewControllerDone:(FolderCommandObject *)folderCommandObject;

@optional
@property (nonatomic, readonly) id<Folder> folder;

@optional
@property (nonatomic, readonly) NSArray *targetFiles;
@end
