//
//  GoogleDriveFolder.h
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"
#import "GoogleDriveServiceManager.h"
#import "CloudFolderDelegate.h"
#import "GoogleDriveFile.h"

@interface GoogleDriveFolder : NSObject <Folder>

@property (weak, nonatomic) id<CloudFolderDelegate>delegate;

+ (GoogleDriveFolder *)getRoot;

@end
