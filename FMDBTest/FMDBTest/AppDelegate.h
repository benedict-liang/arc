//
//  AppDelegate.h
//  FMDBTest
//
//  Created by Benedict Liang on 11/3/13.
//  Copyright (c) 2013 Benedict Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FMDatabase *database;

@end
