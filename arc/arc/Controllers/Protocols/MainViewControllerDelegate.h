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

@protocol MainViewControllerDelegate
- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject;
- (void)secondFileObjectSelected:(id<FileSystemObject>)fileSystemObject;
- (id<FileSystemObject>)currentfile;

# pragma mark - Layout
@property (nonatomic, readonly) BOOL masterViewVisible;
- (void)showMasterViewAnimated:(BOOL)animate;
- (void)hideMasterViewAnimated:(BOOL)animate;

// TODO, refactor these methods
#pragma mark - Others
- (void)refreshCodeViewForSetting:(NSString *)setting;
- (void)openIn:(id<File>)file;
- (void)dropboxAuthentication;

@end
