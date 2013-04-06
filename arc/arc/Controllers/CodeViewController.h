//
//  CodeViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerDelegate.h"
#import "CodeViewDelegate.h"
#import "DetailViewControllerDelegate.h"
#import "File.h"

@interface CodeViewController : UIViewController<SubViewControllerDelegate,
    CodeViewDelegate, UITableViewDataSource,
    UITableViewDelegate, DetailViewControllerDelegate, UISearchDisplayDelegate>
@end
