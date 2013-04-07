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

@interface SettingsViewController : UIViewController <SubViewControllerDelegate,
    UITableViewDelegate, UITableViewDataSource>
- (void)registerPlugin:(id<PluginDelegate>)plugin;
@end
