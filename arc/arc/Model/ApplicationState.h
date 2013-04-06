//
//  ApplicationState.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "Folder.h"
#import "RootFolder.h"

@interface ApplicationState : NSObject
+ (ApplicationState*)sharedApplicationState;

@property (strong, nonatomic) id<File> currentFileOpened;
@property (strong, nonatomic) id<Folder> currentFolderOpened;

//
// Settings and Preferences
//
// Font Dictionary
@property (nonatomic, strong) NSDictionary* fonts;

// Given an array of Setting Keys,
// return a Dictionary with keys as settingKeys and
// values as corresponding setting Values
- (id)settingsForKeys:(NSArray *)settingKeys;

// Given a key, returns the corresponding setting.
- (id)settingForKey:(NSString *)key;

// Updates the setting stored with the given key.
- (void)setSetting:(id)value forKey:(NSString *)key;

// Saves settings to disk.
- (void)saveStateToDisk;

// tmp
// Returns a sample file.
+ (id<File>)getSampleFile;

@end
