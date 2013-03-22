//
//  FileObject.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject {
    @private
    NSURL* _url;
}

// The name of this object.
@property (strong, nonatomic) NSString* name;

// The full file path of this object.
@property (strong, nonatomic) NSString* path;

// The parent of this object (if any.)
@property (weak, nonatomic) FileObject* parent;

// Creates a FileObject to represent the given URL.
// url should be an object on the file system.
- (id)initWithURL:(NSURL*)url;

@end
