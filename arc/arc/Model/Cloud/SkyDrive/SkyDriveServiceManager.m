//
// Created by Jerome on 13/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveServiceManager.h"

@interface SkyDriveServiceManager ()
@property BOOL isLoggedIn;
@end


static SkyDriveServiceManager *sharedServiceManager = nil;

@implementation SkyDriveServiceManager

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
        NSArray *scopesRequired = [NSArray arrayWithObjects:SKYDRIVE_SCOPE_SIGNIN, SKYDRIVE_SCOPE_READ_ACCESS, nil];
        _liveClient = [[LiveConnectClient alloc] initWithClientId:CLOUD_SKYDRIVE_KEY scopes:scopesRequired delegate:self];
        _isLoggedIn = NO;
    }
    return self;
}

// Takes in a ViewController.
// Triggers the cloud service's login procedure.
- (void)loginWithViewController:(UIViewController *)controller
{
    [_liveClient login:controller delegate:self];
}

- (void)authCompleted:(LiveConnectSessionStatus)status session:(LiveConnectSession *)session userState:(id)userState
{
    if (session != nil) {
        _isLoggedIn = YES;
    }
}

- (void)authFailed:(NSError *)error userState:(id)userState
{
    _isLoggedIn = NO;
}

// Takes in a File object (representing a file on the cloud service), and a LocalFolder.
// Downloads the file and stores it in the LocalFolder.
- (void)downloadFile:(SkyDriveFile *)file toFolder:(LocalFolder *)folder
{
    if (_isLoggedIn) {
        SkyDriveDownloadHelper *helper = [[SkyDriveDownloadHelper alloc] initWithFile:file Folder:folder];
        [_liveClient downloadFromPath:[file identifier] delegate:helper];
    }
}

@end