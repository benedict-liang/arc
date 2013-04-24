//
//  MasterViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MasterViewControllerDelegate <NSObject>
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, strong) UITabBarController *tabBarController;
@end
