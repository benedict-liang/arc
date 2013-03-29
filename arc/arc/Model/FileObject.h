//
//  FileObject.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject {
    @protected
    id _contents;
    BOOL _needsRefresh;
}

// The name of this object.
@property (strong, nonatomic) NSString* name;

// The NSURL of this object.
@property (strong, nonatomic) NSURL* url;

// The parent of this object (if any.)
@property (weak, nonatomic) FileObject* parent;

// Creates a FileObject to represent the given URL,
// with its parent set to the given FileObject.
- (id)initWithURL:(NSURL*)url parent:(FileObject*)parent;

// Refreshes the contents of this object by reloading
// them from the file system.
// Returns the contents when done.
- (id)refreshContents;

// Flags this object as needing its contents refreshed.
- (void)flagForRefresh;

// Gets the contents of this object.
- (id)contents;

// Removes this object from the file system.
// Returns YES if successful, NO otherwise.
- (BOOL)remove;

@end
