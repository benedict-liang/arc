//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "SubViewControllerProtocol.h"

@interface FolderViewController : UIViewController <SubViewControllerProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly) id<Folder> folder;
- (id)initWithFolder:(id<Folder>)folder;
@end
