//
//  CloudPickerViewController.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudFolder.h"
#import "CloudServiceManager.h"
#import "CloudFolderDelegate.h"

@interface CloudPickerViewController : UITableViewController <CloudFolderDelegate>

- (id)initWithCloudFolder:(id<CloudFolder>)folder targetFolder:(LocalFolder *)target serviceManager:(id<CloudServiceManager>)serviceManager;

@end
