//
//  CloudFolder.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"
#import "CloudFolderDelegate.h"

@protocol CloudFolder <NSObject, Folder>

@property (weak, nonatomic) id<CloudFolderDelegate> delegate;

+ (id<CloudFolder>)getRoot;

- (void)updateContents;
- (void)cancelOperations;

- (BOOL)hasOngoingOperations;

@end
