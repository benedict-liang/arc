//
//  MainViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootFolder.h"
#import "Folder.h"
#import "File.h"

#import "ApplicationState.h"

#import "FileNavigationViewController.h"
#import "CodeViewController.h"
#import "MainViewControllerDelegate.h"

@interface MainViewController : UIViewController <MainViewControllerDelegate> {
    @private
    RootFolder *_rootFolder;
    CodeViewController *_codeViewController;
    FileNavigationViewController *_fileNavigator;
}


// Returns the MainViewController singleton.
//+ (MainViewController*) getInstance;

@end
