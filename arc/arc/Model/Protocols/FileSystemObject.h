//
//  FileSystemObject.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileSystemObject <NSObject>

@required

// The name of this object.
@property (strong, nonatomic) NSString *name;

// This should be able to be used to reconstruct whatever is needed
// to actually access the file/folder.
@property (strong, nonatomic) NSString *identifier;

// The parent of this object.
@property (weak, nonatomic) id<FileSystemObject> parent;

// Whether or not this object can be removed.
@property BOOL isRemovable;

// The size of this object. Folders should return the number of objects
// within, Files their size in bytes.
@property float size;

// Returns the contents of this object.
- (id<NSObject>)contents;

@optional
// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent;

@end
