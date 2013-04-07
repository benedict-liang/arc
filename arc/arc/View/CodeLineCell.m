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
@property (nonatomic, strong) UILabel *lineNumberLabel;
@end

@implementation CodeLineCell
@synthesize line = _line;
@synthesize lineNumber = _lineNumber;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setLine:(CTLineRef)line
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    _lineNumberLabel = [[UILabel alloc] init];
    _lineNumberLabel.text = [NSString stringWithFormat:@"%d",_lineNumber];
    [self.contentView addSubview:_lineNumberLabel];
    
    _line = line;
    _codeLine = [[CodeLine alloc] initWithLine:_line];
    [self.contentView addSubview:_codeLine];

    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        _codeLine.backgroundColor = [UIColor blueColor];
    } else {
        _codeLine.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    _lineNumberLabel.frame = CGRectMake(0, 0, 30, self.contentView.bounds.size.height);
    _codeLine.frame = CGRectMake(40, 0, self.contentView.bounds.size.width - 40, self.contentView.bounds.size.height);
}

- (UIView*)backgroundView
{
    return nil;
}

@end
