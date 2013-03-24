//
//  MainViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewControllerDelegate.h"

#import "ApplicationState.h"
#import "RootFolder.h"
#import "Folder.h"
#import "File.h"
#import "FileNavigationViewController.h"
#import "CodeViewController.h"
#import "Constants.h"

@interface MainViewController : UIViewController <MainViewControllerDelegate>
// Returns the MainViewController singleton.
//+ (MainViewController*) getInstance;
@end
