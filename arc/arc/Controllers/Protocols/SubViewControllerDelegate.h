//
//  SubViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewControllerDelegate.h"

@protocol SubViewControllerDelegate <NSObject>
@property (nonatomic, weak) id<MainViewControllerDelegate> delegate;
@end
