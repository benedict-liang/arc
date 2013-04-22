//
//  CloudPickerViewController.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BasicFolderViewController.h"
#import "CloudFolder.h"
#import "CloudServiceManager.h"
#import "CloudFolderDelegate.h"
#import "PresentingModalViewControllerDelegate.h"
#import "ModalViewControllerDelegate.h"

@interface CloudPickerViewController : BasicFolderViewController <CloudFolderDelegate,
    UITableViewDataSource, UITableViewDelegate,
    CloudServiceManagerDelegate, UIAlertViewDelegate,
    ModalViewControllerDelegate>
- (id)initWithCloudFolder:(id<CloudFolder>)folder
             targetFolder:(LocalFolder *)target
           serviceManager:(id<CloudServiceManager>)serviceManager;
@end
