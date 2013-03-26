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

@implementation ApplicationState

// Returns a sample file.
+ (File*)getSampleFile
{
    for (FileObject *currentObject in [[RootFolder getInstance] getContents]) {
        if ([[currentObject name] isEqualToString:@"GameObject.h"]) {
            return (File*)currentObject;
        }
    }
    return nil;
}

@end
