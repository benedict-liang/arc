//
//  CreateFolderViewControllerDelegate.h
//  arc
//
//  Created by Jerome Cheng on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreateFolderViewControllerDelegate <NSObject>
- (void)createFolderWithName:(NSString *)name;

@end
