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
        self.textLabel.font = [UIFont fontWithName:[UI fontName] size:17];
        self.detailTextLabel.font = [UIFont fontWithName:[UI fontName] size:12];
        
        if ([reuseIdentifier isEqualToString:(NSString *)FILECELL_REUSE_IDENTIFIER]) {
            [self setUpFileCellImageView];
        } else if ([reuseIdentifier isEqualToString:(NSString *)FOLDERCELL_REUSE_IDENTIFIER]) {
            [self setUpFolderCellImageView];
        }
        [self setUpSelection];
    }
    return self;
}

- (void)setUpFileCellImageView
{
    self.imageView.image = [Utils scale:[UIImage imageNamed:[UI fileImage]]
                                 toSize:CGSizeMake(35, 35)];
    self.imageView.highlightedImage = [Utils scale:[UIImage imageNamed:[UI fileImageHighlighted]]
                                            toSize:CGSizeMake(35, 35)];
}

- (void)setUpFolderCellImageView
{
    self.imageView.image = [Utils scale:[UIImage imageNamed:[UI folderImage]]
                                 toSize:CGSizeMake(35, 35)];
}

- (void)setUpSelection
{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [Utils lightenColor:[UI navigationBarColor] byPercentage:30];
    self.selectedBackgroundView = backgroundView;
}

- (void)setFileSystemObject:(id<FileSystemObject>)fileSystemObject
{
    _fileSystemObject = fileSystemObject;
    
    NSString *detailDescription;
    if ([[_fileSystemObject class] conformsToProtocol:@protocol(CloudFile)]) {
        id<CloudFile> cloudFile = (id<CloudFile>)fileSystemObject;
        
        NSString *fileSize = [Utils humanReadableFileSize:[cloudFile size]];
        
        switch ([cloudFile downloadStatus]) {
            case kFileDownloading:
                detailDescription = [fileSize stringByAppendingString:@" | Downloading..."];
                break;
            case kFileDownloaded:
                detailDescription = [fileSize stringByAppendingString:@" | Download complete."];
                break;
            case kFileDownloadError:
                detailDescription = [fileSize stringByAppendingString:@" | Download failed."];
                break;
            case kFileNotDownloading:
            default:
                detailDescription = fileSize;
                break;
        }
    } else if ([[_fileSystemObject class] conformsToProtocol:@protocol(File)]) {
        detailDescription = [Utils humanReadableFileSize:_fileSystemObject.size];
    } else if ([[_fileSystemObject class] conformsToProtocol:@protocol(CloudFolder)]) {
        detailDescription = @"";
    } else if ([[_fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        switch ((int)[_fileSystemObject size]) {
            case 0:
                detailDescription = @"Empty Folder";
                break;
            case 1:
                detailDescription = @"1 item";
                break;
            default:
                detailDescription = [NSString stringWithFormat:@"%d items", (int)[_fileSystemObject size]];
                break;
        }
    }

    self.textLabel.text = _fileSystemObject.name;
    self.detailTextLabel.text = detailDescription;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    } else {
        self.selectedBackgroundView.backgroundColor =
        [Utils lightenColor:[UI navigationBarColor] byPercentage:30];;
    }
}

- (void)resetCell
{
    self.editing = NO;
    self.highlighted = NO;
    self.selected = NO;
}

@end
