//
//  ApplicationState.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ApplicationState.h"

@interface ApplicationState ()
@property NSMutableDictionary *_settings;
@end

static ApplicationState *sharedApplicationState = nil;

@implementation ApplicationState

+ (ApplicationState*)sharedApplicationState
{
    if (sharedApplicationState == nil) {
        sharedApplicationState = [[super allocWithZone:NULL] init];
    }
    return sharedApplicationState;
}

// Helper method to get the path of the state plist.
- (NSString *)getStateDictionaryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [[fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] path];
    NSString *settingsPath = [documentsPath stringByAppendingPathComponent:FILE_APP_STATE];
    return settingsPath;
}

// Helper method to retrieve the saved state from the plist.
- (NSDictionary *)retrieveSavedState
{
    NSString *settingsPath = [self getStateDictionaryPath];
    NSDictionary *storedState = [NSDictionary dictionaryWithContentsOfFile:settingsPath];
    return storedState;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Get the stored settings dictionary.
        NSDictionary *storedState = [self retrieveSavedState];
        NSDictionary *storedSettings = [storedState valueForKey:KEY_SETTINGS_ROOT];
    
        // Restore settings from the dictionary.
        _fontFamily = [storedSettings valueForKey:KEY_FONT_FAMILY];
        _fontSize = [(NSNumber*)[storedSettings valueForKey:KEY_FONT_SIZE] intValue];
        _wordWrap = (BOOL)[storedSettings valueForKey:KEY_WORD_WRAP];
        _lineNumbers = (BOOL)[storedSettings valueForKey:KEY_LINE_NUMBERS];
        
        // Restore application state.
        _currentFolderOpened = [RootFolder sharedRootFolder];
        _currentFileOpened = nil;
        _fonts = [storedState valueForKey:KEY_FONTS];
    }
    return self;
}

// Saves settings to disk.
- (void)saveStateToDisk
{
    // Get the stored settings dictionary.
    NSMutableDictionary *savedState = [[self retrieveSavedState] mutableCopy];
    
    // Set our application state.
    [savedState setValue:[_currentFolderOpened path] forKey:KEY_CURRENT_FOLDER];
    [savedState setValue:[_currentFileOpened path] forKey:KEY_CURRENT_FILE];
    
    // Save our settings into a dictionary.
    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] init];
    [settingsDictionary setValue:_fontFamily forKey:KEY_FONT_FAMILY];
    [settingsDictionary setValue:[NSNumber numberWithInt:_fontSize] forKey:KEY_FONT_SIZE];
    [settingsDictionary setValue:[NSNumber numberWithBool:_wordWrap] forKey:KEY_WORD_WRAP];
    [settingsDictionary setValue:[NSNumber numberWithBool:_lineNumbers] forKey:KEY_LINE_NUMBERS];
    
    [savedState setValue:settingsDictionary forKey:KEY_SETTINGS_ROOT];
    
    // Save the dictionary back to disk.
    [savedState writeToFile:[self getStateDictionaryPath] atomically:YES];
}

// Returns a sample file.
+ (id<File>)getSampleFile
{
    return (id<File>)[[RootFolder sharedRootFolder] retrieveItemWithName:@"GameObject.h"];
}

@end
