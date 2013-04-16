//
//  SkyDriveDownloadHelper.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SkyDriveDownloadHelper.h"

@implementation SkyDriveDownloadHelper

- (id)initWithFile:(SkyDriveFile *)file Folder:(LocalFolder *)folder
{
    if (self = [super init]) {
        _file = file;
        _folder = folder;
    }
    return self;
}

- (void)liveOperationSucceeded:(LiveDownloadOperation *)operation
{
    NSData *receivedData = [operation data];
    
    NSString *fileName = [_file name];
    NSString *filePath = [[_folder path] stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:receivedData attributes:nil];
    
    if (_delegate != nil) {
        [_delegate downloadCompleteForHelper:self];
    }
}

- (void)liveOperationFailed:(NSError *)error operation:(LiveDownloadOperation *)operation
{
    if (_delegate != nil) {
        [_delegate downloadFailedForHelper:self];
    }
}

@end
