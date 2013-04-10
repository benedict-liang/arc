//
//  LeftBarViewController.h
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerDelegate.h"
#import "MasterViewControllerDelegate.h"
#import "FileNavigatorViewControllerDelegate.h"
#import "SettingsViewDelegate.h"

@interface LeftViewController : UIViewController<SubViewControllerDelegate,
    MasterViewControllerDelegate, FileNavigatorViewControllerDelegate,
    SettingsViewDelegate, UITabBarControllerDelegate>
@end
