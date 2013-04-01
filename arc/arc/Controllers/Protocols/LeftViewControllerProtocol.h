//
//  LeftViewControllerProtocol.h
//  arc
//
//  Created by Yong Michael on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"

@protocol LeftViewControllerProtocol <NSObject>
- (void)showFolder:(id<Folder>)folder;
@end
