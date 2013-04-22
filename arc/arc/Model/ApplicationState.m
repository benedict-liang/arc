//
//  ApplicationState.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ApplicationState.h"

@interface ApplicationState ()
@property (strong, nonatomic) NSMutableDictionary *settings;
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

- (id)init
{
    self = [super init];
    if (self) {
        // Get the stored settings dictionary.
        NSMutableDictionary *storedState = [self retrieveSavedState];
        _settings = [storedState valueForKey:KEY_SETTINGS_ROOT];
        if (_settings == nil) {
            _settings = [NSMutableDictionary dictionary];
        }
        
        // Restore application state.
        NSString *folderPath = [storedState valueForKey:KEY_CURRENT_FOLDER];
        NSString *filePath = [storedState valueForKey:KEY_CURRENT_FILE];
        
        // If we have no folder path, we should set a default.
        if (!folderPath) {
            folderPath = [[LocalRootFolder sharedLocalRootFolder] identifier];
        }
        
        // TEMPORARILY set a default for the current file.
        if (!filePath) {
            filePath = [[ApplicationState defaultFile] identifier];
        }

        _currentFolderOpened = (id<Folder>)[[RootFolder sharedRootFolder] objectAtPath:folderPath];
        _currentFileOpened = (id<File>)[[RootFolder sharedRootFolder] objectAtPath:filePath];
        _fonts = [storedState valueForKey:KEY_FONTS];
    }
    return self;
}

- (void)setCurrentFileOpened:(id<File>)currentFileOpened
{
    _currentFileOpened = currentFileOpened;
    [self setSetting:[currentFileOpened identifier]
              forKey:KEY_CURRENT_FILE];
}

- (void)setCurrentFolderOpened:(id<Folder>)currentFolderOpened
{
    _currentFolderOpened = currentFolderOpened;
    [self setSetting:[currentFolderOpened identifier]
              forKey:KEY_CURRENT_FOLDER];
}

// Helper method to get the path of the state plist.
- (NSString *)getStateDictionaryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [[fileManager URLForDirectory:NSDocumentDirectory
                                                   inDomain:NSUserDomainMask
                                          appropriateForURL:nil
                                                     create:YES
                                                      error:nil] path];
    
    NSString *settingsPath =
    [documentsPath stringByAppendingPathComponent:FILE_APP_STATE];
    
    return settingsPath;
}

// Helper method to retrieve the saved state from the plist.
- (NSMutableDictionary *)retrieveSavedState
{
    NSString *settingsPath = [self getStateDictionaryPath];
    NSMutableDictionary *storedState =
    [NSMutableDictionary dictionaryWithContentsOfFile:settingsPath];
    return storedState;
}

- (id)settingsForKeys:(NSArray *)settingKeys
{
    NSMutableDictionary *settingsDict = [NSMutableDictionary dictionary];
    
    for (NSString *settingKey in settingKeys) {
        [settingsDict setObject:[self settingForKey:settingKey]
                         forKey:settingKey];
    }
    
    return settingsDict;
}

// Given a key, returns the corresponding setting.
- (id)settingForKey:(NSString *)key
{
    return [_settings valueForKey:key];
}

// Updates the setting stored with the given key.
- (void)setSetting:(id)value forKey:(NSString *)key
{
    [_settings setValue:value
                 forKey:key];
    
    [self saveStateToDisk];
}

// Saves settings to disk.
- (void)saveStateToDisk
{
    // Get the stored settings dictionary.
    NSMutableDictionary *savedState = [[self retrieveSavedState] mutableCopy];
    
    // Set our application state.
    [savedState setValue:[_currentFolderOpened identifier]
                  forKey:KEY_CURRENT_FOLDER];
    
    [savedState setValue:[_currentFileOpened identifier]
                  forKey:KEY_CURRENT_FILE];
    
    // Save our settings.
    [savedState setValue:_settings
                  forKey:KEY_SETTINGS_ROOT];
    
    // Save the dictionary back to disk.
    [savedState writeToFile:[self getStateDictionaryPath]
                 atomically:YES];
}

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // Only set default setting if setting value is not set
    if (![self settingForKey:[plugin setting]]) {
        [self setSetting:[plugin defaultValue]
                  forKey:[plugin setting]];
    }
}

// Returns the default file
+ (id<File>)defaultFile;
{
    return (id<File>)[[RootFolder sharedRootFolder]
                      retrieveItemWithName:DEFAULT_FILE];
}

@end
