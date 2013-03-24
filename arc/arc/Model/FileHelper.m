//
//  FileHelper.m
//  arc
//
//  Created by Jerome Cheng on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileHelper.h"
#import "Constants.h"

@implementation FileHelper

// Used to handle files passed in from other applications through iOS' "Open in..."
// Moves the file into External Applications, then returns it.
+ (File*)fileWithURL:(NSURL *)url sourceApplication:(NSString *)application annotation:(id)annotation
{
    // Get the "Inbox" folder where it's stored.
    RootFolder *root = [RootFolder getInstance];
    NSURL *inboxURL = [url URLByDeletingLastPathComponent];
    Folder *inboxFolder = [[Folder alloc] initWithURL:inboxURL parent:root];
    
    // Get the External Applications folder.
    NSArray *rootContents = [root getContents];
    Folder *externalFolder;
    for (FileObject *currentObject in rootContents) {
        if ([currentObject isKindOfClass:[Folder class]] && [[currentObject name] isEqualToString:FOLDER_EXTERNAL_APPLICATIONS]) {
            externalFolder = (Folder*)currentObject;
            break;
        }
    }
    
    // Create a File object for the received file.
    File *receivedDocument = [[File alloc] initWithURL:url parent:inboxFolder];
    
    // Move it to External Applications.
    BOOL isMoveSuccessful = [externalFolder takeFile:receivedDocument];
    if (isMoveSuccessful) {
        // Get rid of the Inbox folder.
        [inboxFolder remove];
        return receivedDocument;
    }
    return nil;
}

@end
