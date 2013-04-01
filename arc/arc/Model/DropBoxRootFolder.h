//
//  DropBoxRootFolder.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>
#import "DropBoxFolder.h"
#import "Constants.h"

@interface DropBoxRootFolder : DropBoxFolder

+ (DropBoxRootFolder *)sharedDropBoxRootFolder;

@end
