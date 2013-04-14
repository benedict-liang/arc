//
//  ResultsTableViewController.h
//  arc
//
//  Created by Benedict Liang on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeViewController.h"

@interface ResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *resultsArray;
@property (strong, nonatomic) CodeViewController *codeViewController;

@end
