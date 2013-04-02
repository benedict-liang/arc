//
//  MainViewControllerDelegate.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemObject.h"
#import "File.h"
#import "Folder.h"

@protocol MainViewControllerProtocol
#pragma mark - Triggered by CodeViewController
- (void)showLeftBar;
- (void)hideLeftBar;

#pragma mark - Triggered by LeftBarViewController
- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject;

// TODO, refactor these methods
#pragma mark - Others
- (void)openIn:(id<File>)file;
- (void)dropboxAuthentication;

@end
