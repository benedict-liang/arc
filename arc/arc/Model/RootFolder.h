//
//  RootFolder.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "Folder.h"
#import "DropBoxRootFolder.h"
#import "LocalRootFolder.h"

/**
 RootFolder is a wrapper around LocalRootFolder, used to allow
 multiple file systems to co-exist.
 
 (arc) supports DropBox's Sync API, which uses its own internal
 file system. In addition, the native iOS file system is used
 for all other services.
 
 RootFolder passes all messages received to LocalRootFolder's instance,
 and only interferes with refreshContents: it takes the array returned
 by LocalRootFolder, and adds the DropBoxRootFolder to it.
 */

@interface RootFolder : NSObject <Folder> {
    NSArray *_contents;
    BOOL _needsRefresh;
}

+ (RootFolder *)sharedRootFolder;

@end
