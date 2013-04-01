//
//  MainViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewControllerProtocol.h"
#import "Constants.h"
#import "ApplicationState.h"
#import "RootFolder.h"
#import "Folder.h"
#import "File.h"
#import "CodeViewController.h"
#import "LeftViewController.h"

#import "TMBundleHeader.h"

@interface MainViewController : UISplitViewController <MainViewControllerProtocol>
@end
