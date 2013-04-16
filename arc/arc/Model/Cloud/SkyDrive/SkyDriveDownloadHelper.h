//
//  SkyDriveDownloadHelper.h
//  arc
//
//  Used to move a downloaded file from SkyDrive into the local file system.
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiveSDK/LiveConnectClient.h>
#import "LocalFolder.h"
#import "SkyDriveFile.h"
#import "DownloadHelperDelegate.h"

@interface SkyDriveDownloadHelper : NSObject <LiveDownloadOperationDelegate>

@property (weak, nonatomic) id<DownloadHelperDelegate> delegate;
@property (weak, nonatomic) SkyDriveFile *file;
@property (weak, nonatomic) LocalFolder *folder;

- (id)initWithFile:(SkyDriveFile *)file Folder:(LocalFolder *)folder;

@end
