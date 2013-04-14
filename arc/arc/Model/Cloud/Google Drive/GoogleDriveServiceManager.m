//
//  GoogleDriveServiceManager.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveServiceManager.h"

static GoogleDriveServiceManager *sharedServiceManager = nil;

@implementation GoogleDriveServiceManager

- (BOOL)isLoggedIn
{
    return [((GTMOAuth2Authentication *)_driveService.authorizer) canAuthorize];
}

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
    }
    return self;
}


// Takes in a ViewController.
// Triggers the cloud service's login procedure.
- (void)loginWithViewController:(UIViewController *)controller
{
    GTMOAuth2ViewControllerTouch *loginController = [[GTMOAuth2ViewControllerTouch alloc]
                                                     initWithScope:kGTLAuthScopeDriveReadonly clientID:CLOUD_GOOGLE_ID clientSecret:CLOUD_GOOGLE_SECRET keychainItemName:GOOGLE_KEYCHAIN_NAME delegate:self finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [[controller navigationController] pushViewController:loginController animated:YES];
}

// Handle authentication from Drive.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (!error) {
        _driveService.authorizer = authResult;
    }
}

@end
