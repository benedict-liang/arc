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

@interface FolderViewController : UITableViewController

- (id)initWithFolder:(id<Folder>)folder;

@end
