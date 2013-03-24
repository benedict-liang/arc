//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "SubViewController.h"

@interface FileNavigationViewController : UITableViewController <SubViewController, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) NSArray* data;

- (id)initWithFolder:(Folder *)folder frame:(CGRect)frame;
// define delegate property
@property (nonatomic, assign) id delegate;
//@property UINavigationController* navigationController;
@property UITableView* table;
@property UIWindow* window;
//TODO: needs update view methods upon adding a) a file b) a folder. Alternatively, it could take in a FileObject.
@end
