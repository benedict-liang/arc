//
// Created by Jerome on 13/4/13.
//
//

#import <Foundation/Foundation.h>
#import "LocalFolder.h"

@protocol CloudServiceManager <NSObject>

// Returns the singleton service manager for this particular service.
+ (id<CloudServiceManager>)sharedServiceManager;

// Takes in a ViewController.
// Triggers the cloud service's login procedure.
- (void)loginWithViewController:(UIViewController *)controller;

// Takes in a File object (representing a file on the cloud service), and a LocalFolder.
// Downloads the file and stores it in the LocalFolder.
- (void)downloadFile:(id<File>)file toFolder:(LocalFolder *)folder;

@end