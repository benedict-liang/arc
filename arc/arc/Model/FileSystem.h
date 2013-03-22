//
//  FileSystem.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"

@interface FileSystem : NSObject {
    @private
    Folder *_rootFolder; // The root folder.
}

// Returns the root folder of the entire file system.
- (Folder*)getRootFolder;

// Returns the single FileSystem instance.
+ (FileSystem*)getInstance;

// Returns an NSArray of FileObjects, corresponding to the contents
// of the given folder.
- (NSArray*)getFolderContents:(Folder*)folder;

// Returns an NSString containing the contents of the given file.
- (NSString*)getFileContents:(File*)file;

@end
