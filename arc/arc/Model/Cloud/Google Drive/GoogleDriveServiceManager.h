//
//  GoogleDriveServiceManager.h
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudServiceManager.h"
#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GoogleDriveDownloadHelper.h"

@interface GoogleDriveServiceManager : NSObject <CloudServiceManager>

@property (strong, nonatomic) GTLServiceDrive *driveService;

@end
