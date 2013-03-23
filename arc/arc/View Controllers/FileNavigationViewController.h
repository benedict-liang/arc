//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewController.h"

@interface FileNavigationViewController : UITableViewController <SubViewController, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) NSArray* data;

//Currently files is considered an array of strings. I'm thinking it would be helpful to pass the filesystem here, as the FileNavigator would need to view the file heirarchy.
-(id)initWithFiles:(NSArray*)files;

//TODO: needs update view methods upon adding a) a file b) a folder. Alternatively, it could take in a FileObject.
@end
