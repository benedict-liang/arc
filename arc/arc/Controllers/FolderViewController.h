//
//  FolderViewController.h
//  arc
//
//  Created by Jerome Cheng on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "File.h"
#import "FolderViewControllerDelegate.h"
#import "FileObjectTableViewCell.h"

@interface FolderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<FolderViewControllerDelegate> delegate;
@property BOOL isEditAllowed;

- (id)initWithFolder:(id<Folder>)folder;

@end
