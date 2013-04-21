//
//  SettingsViewController.h
//  arc
//
//  Created by Yong Michael on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerDelegate.h"
#import "ApplicationState.h"
#import "PluginDelegate.h"
#import "SettingCell.h"
#import "LongSettingListViewController.h"
#import "LongSettingListViewControllerDelegate.h"

@interface SettingsViewController : UIViewController <SubViewControllerDelegate,
    UITableViewDelegate, UITableViewDataSource, LongSettingListViewControllerDelegate>
- (void)registerPlugin:(id<PluginDelegate>)plugin;

@end
