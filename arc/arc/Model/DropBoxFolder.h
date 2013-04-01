//
//  DropBoxFolder.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "Folder.h"

@interface DropBoxFolder : NSObject <Folder> {
    NSArray *_contents;
    BOOL _needsRefresh;
}

@end
