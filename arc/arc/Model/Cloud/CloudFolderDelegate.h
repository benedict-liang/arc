//
//  CloudFolderDelegate.h
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"

@protocol CloudFolderDelegate <NSObject>

- (void)folderContentsUpdated:(id<Folder>)sender;

@end
