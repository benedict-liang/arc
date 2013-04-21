//
//  FolderCommandObject.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kMoveFileObjects
} kFolderCommandType;

@interface FolderCommandObject : NSObject
@property (nonatomic, readonly) kFolderCommandType type;
@property (nonatomic, readonly) id target;
+ (FolderCommandObject*)commandOfType:(kFolderCommandType)type withTarget:(id)target;
@end
