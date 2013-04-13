//
// Created by Jerome on 13/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SkyDriveServiceManager.h"

@interface SkyDriveServiceManager ()
@property (strong, nonatomic) LiveConnectClient *liveClient;
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
        NSArray *scopesRequired = [NSArray arrayWithObjects:SKYDRIVE_SCOPE_SIGNIN, SKYDRIVE_SCOPE_READ_ACCESS];
        _liveClient = [[LiveConnectClient alloc] initWithClientId:CLOUD_SKYDRIVE_KEY scopes:scopesRequired delegate:self];
    }
    return self;
}

@end