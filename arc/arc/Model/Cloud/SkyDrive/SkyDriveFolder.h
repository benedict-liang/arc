//
// Created by Jerome on 14/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Folder.h"
#import "SkyDriveServiceManager.h"
#import "SkyDriveFile.h"
#import "CloudFolderDelegate.h"

@interface SkyDriveFolder : NSObject <Folder, LiveOperationDelegate>

@property (weak, nonatomic) id<CloudFolderDelegate> delegate;

+ (SkyDriveFolder *)getRoot;

@end