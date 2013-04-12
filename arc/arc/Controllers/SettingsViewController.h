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

@interface SettingsViewController : UIViewController <SubViewControllerDelegate,
    UITableViewDelegate, UITableViewDataSource>
- (void)registerPlugin:(id<PluginDelegate>)plugin;
- (void)updateSetting:(id<NSObject>)value
        forSettingKey:(NSString*)settingKey
      reloadTableData:(Boolean)reloadData;
@end
