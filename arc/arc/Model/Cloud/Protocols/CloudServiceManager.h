//
// Created by Jerome on 13/4/13.
//
//

#import <Foundation/Foundation.h>
#import "LocalFolder.h"

@protocol CloudServiceManager <NSObject>

// Takes in a ViewController and an optional delegate.
// Triggers the cloud service's login procedure.
+ (void)loginWithViewController:(UIViewController *)controller delegate:(id)delegate;

// Takes in a path on the file service, and a LocalFolder.
// Downloads the file at that path and stores it in the LocalFolder.
// Returns YES if successful, NO otherwise.
+ (BOOL)downloadFileAtPath:(NSString *)path toFolder:(LocalFolder *)folder;

@end