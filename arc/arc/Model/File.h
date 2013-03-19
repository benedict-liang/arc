//
//  File.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@interface File : FileObject

// Returns an NSString containing the full contents of this file.
- (NSString*)getContents;

@end
