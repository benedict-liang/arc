//
//  DropBoxManager.h
//  arc
//
//  Created by Jerome Cheng on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "FileObject.h"
#import "File.h"
#import "Folder.h"

@interface DropBoxManager : NSObject

// Downloads the given DBFile into the given Folder.
// Returns the resulting File object if successful, nil otherwise.
+ (File*)saveDBFile:(DBFile*)dbFile toFolder:(Folder*)folder;

@end
