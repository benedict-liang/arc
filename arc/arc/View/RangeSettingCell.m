//
//  RangeSettingCell.m
//  arc
//
//  Created by Yong Michael on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RangeSettingCell.h"

@interface RangeSettingCell ()
@end

@implementation RangeSettingCell
@synthesize slider = _slider;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        _slider = [[UISlider alloc] init];
        _slider.autoresizingMask = UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_slider];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // TODO.
}

- (void)layoutSubviews
{
    _slider.bounds = CGRectMake(30, 0,
        self.contentView.bounds.size.width - 60, _slider.bounds.size.height);
    _slider.center = self.contentView.center;
}

@end
