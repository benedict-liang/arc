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

// The extension of this file.
@property (strong, nonatomic) NSString *extension;

@end
