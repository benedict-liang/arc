//
//  LocalRootFolder.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalFolder.h"
#import "Constants.h"

@interface LocalRootFolder : LocalFolder

+ (LocalRootFolder *)sharedLocalRootFolder;

@end
