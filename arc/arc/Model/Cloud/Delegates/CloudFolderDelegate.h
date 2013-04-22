//
//  CloudFolderDelegate.h
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CloudFolderDelegate <NSObject>

- (void)folderContentsUpdated:(id)sender;

- (void)folderReportsAuthFailed:(id)sender;

- (void)folderOperationCountChanged:(id)sender;
@end
