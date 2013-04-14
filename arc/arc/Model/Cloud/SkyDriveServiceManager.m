//
// Created by Jerome on 13/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveServiceManager.h"

@interface SkyDriveServiceManager ()
@property (strong, nonatomic) LiveConnectClient *liveClient;
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
    _isLoggedIn = YES;
}

- (void)authFailed:(NSError *)error userState:(id)userState
{
    _isLoggedIn = NO;
}

// Takes in a path on the file service, and a LocalFolder.
// Downloads the file at that path and stores it in the LocalFolder.
// Returns YES if successful, NO otherwise.
- (BOOL)downloadFileAtPath:(NSString *)path toFolder:(LocalFolder *)folder
{
    if (_isLoggedIn) {
        // Get file details.


        LiveDownloadOperation *operation = [_liveClient downloadFromPath:path delegate:nil];
        NSData *receivedData = [operation data];

        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager createFileAtPath:[folder path] contents:<#(NSData *)data#> attributes:<#(NSDictionary *)attr#>]
    }
    return NO;
}

@end