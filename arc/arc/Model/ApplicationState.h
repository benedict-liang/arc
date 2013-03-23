//
//  ApplicationState.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "Folder.h"

@interface ApplicationState : NSObject

@property (strong, nonatomic) File *currentFileOpened;
@property (strong, nonatomic) Folder *currentFolderOpened;

@end
