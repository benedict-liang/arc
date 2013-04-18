//
//  FolderViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FolderViewController;

@protocol FolderViewControllerDelegate <NSObject>
- (void)folderViewController:(FolderViewController*)folderviewController DidEnterEditModeAnimate:(BOOL)animate;
- (void)folderViewController:(FolderViewController*)folderviewController DidExitEditModeAnimate:(BOOL)animate;
@end
