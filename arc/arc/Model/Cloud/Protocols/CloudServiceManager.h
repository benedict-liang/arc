//
// Created by Jerome on 13/4/13.
//
//

#import <Foundation/Foundation.h>
#import "LocalFolder.h"
#import "CloudFile.h"

@protocol CloudServiceManager <NSObject>

// Returns the singleton service manager for this particular service.
+ (id<CloudServiceManager>)sharedServiceManager;

// Takes in a ViewController.
// Triggers the cloud service's login procedure.
- (void)loginWithViewController:(UIViewController *)controller;

// Takes in a CloudFile object, and a LocalFolder.
// Downloads the file and stores it in the LocalFolder.
- (void)downloadFile:(id<CloudFile>)file toFolder:(LocalFolder *)folder;

- (BOOL)isLoggedIn;

@end