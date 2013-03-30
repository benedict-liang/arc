//
//  ApplicationState.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ApplicationState.h"
// Temporary imports. Remove when getSampleFile is no longer needed.
#import "FileObject.h"
#import "RootFolder.h"
// End of temporary imports.

@interface ApplicationState ()
@property NSMutableDictionary *_settings;
@end

static ApplicationState *sharedApplicationState = nil;

@implementation ApplicationState
@synthesize _settings = __settings;
@synthesize currentFileOpened = _currentFileOpened;
@synthesize currentFolderOpened = _currentFolderOpened;

+ (ApplicationState*)sharedApplicationState
{
    if (sharedApplicationState == nil) {
        sharedApplicationState = [[super allocWithZone:NULL] init];
    }
    return sharedApplicationState;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Defaults || Get Previous State from plist
        _currentFolderOpened = [RootFolder sharedRootFolder];
        _currentFileOpened = nil;
    }
    return self;
}

- (NSDictionary*)settings
{
    return [NSDictionary dictionaryWithDictionary:__settings];
}

// Returns a sample file.
+ (File*)getSampleFile
{
    for (FileObject *currentObject in [[RootFolder sharedRootFolder] contents]) {
        if ([[currentObject name] isEqualToString:@"GameObject.h"]) {
            return (File*)currentObject;
        }
    }
    return nil;
}

@end
