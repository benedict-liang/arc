//
//  CloudFile.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@protocol CloudFile <File>

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier size:(float)size;

@end
