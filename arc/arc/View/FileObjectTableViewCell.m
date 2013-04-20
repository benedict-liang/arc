//
//  FileObjectTableViewCell.m
//  arc
//
//  Created by Yong Michael on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObjectTableViewCell.h"

const NSString *FILECELL_REUSE_IDENTIFIER = @"fileCell";
const NSString *FOLDERCELL_REUSE_IDENTIFIER = @"folderCell";

@implementation FileObjectTableViewCell
@synthesize fileSystemObject = _fileSystemObject;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:(NSString *)FILECELL_REUSE_IDENTIFIER]) {
            self.imageView.image = [Utils scale:[UIImage imageNamed:@"file.png"]
                                         toSize:CGSizeMake(35, 35)];
            self.imageView.highlightedImage = [Utils scale:[UIImage imageNamed:@"file_white.png"]
                                                    toSize:CGSizeMake(35, 35)];
        } else if ([reuseIdentifier isEqualToString:(NSString *)FOLDERCELL_REUSE_IDENTIFIER]) {
            self.imageView.image = [Utils scale:[UIImage imageNamed:@"folder.png"]
                                         toSize:CGSizeMake(35, 35)];
        }
        
        // selection
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [Utils colorWithHexString:@"ee151512"];
        self.selectedBackgroundView = bg;
    }
    return self;
}

- (void)setFileSystemObject:(id<FileSystemObject>)fileSystemObject
{
    _fileSystemObject = fileSystemObject;
    
    NSString *detailDescription;
    if ([[_fileSystemObject class] conformsToProtocol:@protocol(File)]) {
        detailDescription = [Utils humanReadableFileSize:_fileSystemObject.size];
    } else if ([[_fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        if (_fileSystemObject.size == 0) {
            detailDescription = @"Empty Folder";
        } else if (_fileSystemObject.size == 1) {
            detailDescription = [NSString stringWithFormat:@"%d item", (int)_fileSystemObject.size];
        } else {
            detailDescription = [NSString stringWithFormat:@"%d items", (int)_fileSystemObject.size];
        }
    }

    self.textLabel.text = _fileSystemObject.name;
    self.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
    self.detailTextLabel.text = detailDescription;
    self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
}
@end
