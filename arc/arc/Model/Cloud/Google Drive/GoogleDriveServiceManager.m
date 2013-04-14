//
//  GoogleDriveServiceManager.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveServiceManager.h"

@interface GoogleDriveServiceManager ()
@property BOOL isLoggedIn;
@end


static GoogleDriveServiceManager *sharedServiceManager = nil;

@implementation GoogleDriveServiceManager

// Returns the singleton service manager for this particular service.
+ (id<CloudServiceManager>)sharedServiceManager
{
    if (sharedServiceManager == nil) {
        sharedServiceManager = [[super allocWithZone:NULL] init];
    }
    return sharedServiceManager;
}

- (id)init
{
    if (self = [super init]) {
        _driveService = [[GTLServiceDrive alloc] init];
        _driveService.authorizer = [GTMOAuth2ViewControllerTouch
                                    authForGoogleFromKeychainForName:GOOGLE_KEYCHAIN_NAME
                                    clientID:CLOUD_GOOGLE_ID
                                    clientSecret:CLOUD_GOOGLE_SECRET];
        _isLoggedIn = [((GTMOAuth2Authentication *)_driveService.authorizer) canAuthorize];
    }
    return self;
}

@end
