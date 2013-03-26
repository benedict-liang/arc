//
//  CodeViewMiddleware.h
//  arc
//
//  Created by Yong Michael on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@protocol CodeViewMiddleware <NSObject>
// Adds attributes to attributedString
// File object is passed in as a reference (if more infomation is needed)
- (void)execOn:(NSMutableAttributedString*) attributedString FromFile:(File*)file;
@end
