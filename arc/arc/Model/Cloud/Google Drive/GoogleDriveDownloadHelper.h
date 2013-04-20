//
//  GoogleDriveDownloadHelper.h
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleDriveFile.h"
#import "LocalFolder.h"
#import "DownloadHelperDelegate.h"

// This class is used to act as a handler for downloading
// Google Drive files. It acts as a delegate for a download
// operation, and creates a file on the local file system
// when the download is complete.
@interface GoogleDriveDownloadHelper : NSObject

@property (weak, nonatomic) id<DownloadHelperDelegate> delegate;
@property (weak, nonatomic) GoogleDriveFile *file;
@property (weak, nonatomic) LocalFolder *folder;

- (id)initWithFile:(GoogleDriveFile *)file Folder:(LocalFolder *)folder;
- (void)dataRetrieved:(NSData *)data error:(NSError *)error;

@end
