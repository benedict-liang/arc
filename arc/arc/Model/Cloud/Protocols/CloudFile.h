//
//  CloudFile.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

typedef enum { kFileNotDownloading, kFileDownloading, kFileDownloaded, kFileDownloadError } kDownloadStatus;

@protocol CloudFile <File>

@property kDownloadStatus downloadStatus;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier size:(float)size;

@end
