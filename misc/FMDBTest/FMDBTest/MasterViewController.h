//
//  MasterViewController.h
//  FMDBTest
//
//  Created by Benedict Liang on 11/3/13.
//  Copyright (c) 2013 Benedict Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
