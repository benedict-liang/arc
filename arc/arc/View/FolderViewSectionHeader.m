//
//  FolderViewSectionHeader.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FolderViewSectionHeader.h"

@interface FolderViewSectionHeader ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation FolderViewSectionHeader
@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Utils colorWithHexString:@"CC272821"];
        [self setUpLabel];
    }
    return self;
}

- (void)setUpLabel
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(11,-11, 320.0, 44.0)];
    _label.backgroundColor = [UIColor clearColor];
    _label.opaque = NO;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:18];
    _label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _label.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.text = @"";
    [self addSubview:_label];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = _title;
}

@end
