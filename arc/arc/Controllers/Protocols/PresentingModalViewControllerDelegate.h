//
//  CloudPickerViewControllerDelegate.h
//  arc
//
//  Created by Jerome Cheng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FolderCommandObject.h"

@protocol PresentingModalViewControllerDelegate <NSObject>
@property (nonatomic, readonly) id<Folder> folder;
@property (nonatomic, readonly) NSArray *editSelection;
- (void)modalViewControllerDone:(FolderCommandObject *)folderCommandObject;
@end
