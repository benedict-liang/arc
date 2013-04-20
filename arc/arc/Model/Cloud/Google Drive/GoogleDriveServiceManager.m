//
//  GoogleDriveServiceManager.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GoogleDriveServiceManager.h"

static GoogleDriveServiceManager *sharedServiceManager = nil;

@interface GoogleDriveServiceManager ()
@property NSMutableArray *helpers;
@end

@implementation GoogleDriveServiceManager
@synthesize delegate=_delegate;

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
        _helpers = [NSMutableArray array];
    }
    return self;
}


// Takes in a ViewController.
// Triggers the cloud service's login procedure.
- (void)loginWithViewController:(UIViewController *)controller
{
    GTMOAuth2ViewControllerTouch *loginController = [[GTMOAuth2ViewControllerTouch alloc]
                                                     initWithScope:kGTLAuthScopeDriveReadonly clientID:CLOUD_GOOGLE_ID clientSecret:CLOUD_GOOGLE_SECRET keychainItemName:GOOGLE_KEYCHAIN_NAME delegate:self finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [loginController setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller presentViewController:loginController animated:YES completion:nil];
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

// Takes in a File object (representing a file on the cloud service), and a LocalFolder.
// Downloads the file and stores it in the LocalFolder.
- (void)downloadFile:(id<CloudFile>)file toFolder:(LocalFolder *)folder
{
    if ([self isLoggedIn]) {
        [file setDownloadStatus:kFileDownloading];
        GTMHTTPFetcher *httpFetcher = [[_driveService fetcherService] fetcherWithURLString:[file identifier]];
        GoogleDriveDownloadHelper *helper = [[GoogleDriveDownloadHelper alloc] initWithFile:file Folder:folder];
        [helper setDelegate:self];
        
        [_helpers addObject:helper];
        
        [httpFetcher beginFetchWithDelegate:helper didFinishSelector:@selector(fetcher:dataRetrieved:error:)];
    }
}

- (void)downloadCompleteForHelper:(id)sender
{
    [_delegate fileStatusChangedForService:self];
    [_helpers removeObject:sender];
}

- (void)downloadFailedForHelper:(id)sender
{
    [_delegate fileStatusChangedForService:self];
    [_helpers removeObject:sender];
}

@end