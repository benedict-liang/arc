//
//  FileObjectTableViewCell.h
//  arc
//
//  Created by Yong Michael on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSystemObject.h"
#import "File.h"
#import "Folder.h"
#import "CloudFolder.h"
#import "CloudFile.h"

@interface FileObjectTableViewCell : UITableViewCell
extern const NSString *FILECELL_REUSE_IDENTIFIER;
extern const NSString *FOLDERCELL_REUSE_IDENTIFIER;
- (void)setFileSystemObject:(id<FileSystemObject>)fileSystemObject;
@end
