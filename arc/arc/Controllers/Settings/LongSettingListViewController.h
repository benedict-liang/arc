//
//  LongSettingListViewController.h
//  arc
//
//  Created by Jerome Cheng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PluginDelegate.h"
#import "ApplicationState.h"
#import "LongSettingListViewControllerDelegate.h"

@interface LongSettingListViewController : UITableViewController

@property (weak, nonatomic) id<LongSettingListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDictionary *properties;

- (id)initWithProperties:(NSDictionary *)properties delegate:(id)delegate;

@end
