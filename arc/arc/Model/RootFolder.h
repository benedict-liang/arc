//
//  RootFolder.h
//  arc
//
//  Created by Jerome Cheng on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Folder.h"

@interface RootFolder : Folder

// Returns the single RootFolder instance.
+ (RootFolder*)getInstance;

@end
