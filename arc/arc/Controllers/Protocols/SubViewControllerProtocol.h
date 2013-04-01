//
//  SubViewController.h
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewControllerProtocol.h"

@protocol SubViewControllerProtocol <NSObject>
@property (nonatomic, weak) id<MainViewControllerProtocol> delegate;
@end
