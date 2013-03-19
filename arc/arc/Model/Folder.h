//
//  Folder.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@interface Folder : FileObject

// Creates a folder object to represent the given URL.
// url should be a folder on the file system.
- (id)initWithURL:(NSURL*)url;


@end
