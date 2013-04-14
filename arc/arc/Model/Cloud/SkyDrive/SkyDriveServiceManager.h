//
// Created by Jerome on 13/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CloudServiceManager.h"
#import <LiveSDK/LiveConnectClient.h>
#import "SkyDriveDownloadHelper.h"

typedef enum { kFolderListing, kFileInfo } kSkyDriveOperations;

@interface SkyDriveServiceManager : NSObject <CloudServiceManager, LiveAuthDelegate>
@property (strong, nonatomic) LiveConnectClient *liveClient;
@end