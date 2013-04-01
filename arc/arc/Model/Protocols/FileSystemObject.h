//
//  FileSystemObject.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileSystemObject <NSObject>

// The name of this object.
@property (strong, nonatomic) NSString *name;

// The path leading to this object.
// This should be able to be used to reconstruct whatever is needed
// to actually access the file/folder.
@property (strong, nonatomic) NSString *path;

// The parent of this object.
@property (weak, nonatomic) id<FileSystemObject> parent;

// Returns the contents of this object.
- (id<NSObject>)contents;

// Refreshes the contents of this object, and returns them (for convenience.)
- (id<NSObject>)refreshContents;

// Marks this object as needing to be refreshed.
- (void)markNeedsRefresh;

@end
