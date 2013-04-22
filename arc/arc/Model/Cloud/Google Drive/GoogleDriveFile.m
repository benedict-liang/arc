//
//  GoogleDriveFile.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveFile.h"

@implementation GoogleDriveFile

@synthesize name=_name, identifier=_identifier, parent=_parent, size=_size, extension=_extension, isRemovable=_isRemovable, lastModified=_lastModified, downloadStatus=_downloadStatus, isAvailable=_isAvailable;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier size:(float)size
{
    if (self = [super init]) {
        _name = name;
        _identifier = identifier;
        _size = size;
        _extension = [name pathExtension];
        _downloadStatus = kFileNotDownloading;
        _isAvailable = YES;
    }
    return self;
}

- (NSString *)contents
{
    return @"";
}

@end
