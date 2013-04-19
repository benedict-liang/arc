//
//  GoogleDriveDownloadHelper.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveDownloadHelper.h"

@interface GoogleDriveDownloadHelper ()
@property (weak, nonatomic) GoogleDriveFile *file;
@property (weak, nonatomic) LocalFolder *folder;
@end

@implementation GoogleDriveDownloadHelper

- (id)initWithFile:(GoogleDriveFile *)file Folder:(LocalFolder *)folder
{
    if (self = [super init]) {
        _file = file;
        _folder = folder;
    }
    return self;
}

- (void)dataRetrieved:(NSData *)data error:(NSError *)error
{
    if (!error) {
        NSString *fileName = [_file name];
        NSString *filePath = [[_folder identifier] stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    } else {
        NSLog(@"%@", error);
    }
}

@end
