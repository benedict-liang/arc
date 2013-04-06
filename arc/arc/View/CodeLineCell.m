//
//  CodeLineCell.m
//  arc
//
//  Created by Yong Michael on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeLineCell.h"

@interface CodeLineCell ()
@property (nonatomic, strong) CodeLine *codeLine;
@end

@implementation CodeLineCell
@synthesize line = _line;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setLine:(CTLineRef)line
{
    _line = line;
    _codeLine = [[CodeLine alloc] initWithLine:_line];
    [self.contentView addSubview:_codeLine];

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    _codeLine.frame = self.bounds;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        _codeLine.backgroundColor = [UIColor blueColor];
    } else {
        _codeLine.backgroundColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    _codeLine.frame = self.bounds;
}

- (UIView*)backgroundView
{
    return nil;
}

@end
