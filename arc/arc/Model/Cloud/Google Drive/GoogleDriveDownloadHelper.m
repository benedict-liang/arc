//
//  GoogleDriveDownloadHelper.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveDownloadHelper.h"

@implementation GoogleDriveDownloadHelper

- (id)initWithFile:(GoogleDriveFile *)file Folder:(LocalFolder *)folder
{
    if (self = [super init]) {
        _file = file;
        _folder = folder;
    }
    return self;
}

- (void)fetcher:(GTMHTTPFetcher *)fetcher dataRetrieved:(NSData *)data error:(NSError *)error
{
    if (!error) {
        [_file setDownloadStatus:kFileDownloaded];
        [_delegate downloadCompleteForHelper:self];
        
        NSString *fileName = [_file name];
        NSString *filePath = [[_folder identifier] stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    } else {
        [_file setDownloadStatus:kFileDownloadError];
        [_delegate downloadFailedForHelper:self];
        
        NSLog(@"%@", error);
    }
}

@end
