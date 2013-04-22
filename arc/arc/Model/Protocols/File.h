//
//  File.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemObject.h"

@protocol File <FileSystemObject>

@required

// Whether or not this file is available.
@property BOOL isAvailable;

// The extension of this file.
@property (strong, nonatomic) NSString *extension;

// The last modified date of this file.
@property (strong, nonatomic) NSDate *lastModified;

@end
