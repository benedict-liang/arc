//
//  CodeLineCell.m
//  arc
//
//  Created by Yong Michael on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeLineCell.h"

@interface CodeLineCell ()
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) int fontSize;
//@property (nonatomic, strong) CodeLine *codeLine;
@property (nonatomic, strong) UILabel *codeLine;
@property (nonatomic, strong) UILabel *lineNumberLabel;
@end

@implementation CodeLineCell
@synthesize line = _line;
@synthesize lineNumberWidth = _lineNumberWidth;
@synthesize lineNumber = _lineNumber;
@synthesize showLineNumber = _showLineNumber;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // defaults
        _lineNumberWidth = 30;
        _showLineNumber = YES;
        
        _lineNumberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_lineNumberLabel];
        _codeLine = [[UILabel alloc] init];
        [self.contentView addSubview:_codeLine];
    }
    return self;
}

- (void)setForegroundColor:(UIColor*)foregroundColor
{
    _foregroundColor = foregroundColor;
}

- (void)setFontFamily:(NSString*)fontFamily FontSize:(int)fontSize
{
    _fontFamily = fontFamily;
    _fontSize = fontSize;
}

- (void)setLine:(NSAttributedString *)line
{    
    _lineNumberLabel.backgroundColor = [UIColor clearColor];
    _lineNumberLabel.text = @"";
    _lineNumberLabel.textColor = _foregroundColor;
    _lineNumberLabel.font = [UIFont fontWithName:_fontFamily
                                            size:_fontSize];
    _lineNumberLabel.textAlignment = NSTextAlignmentRight;

    _line = line;

    _codeLine.attributedText = _line;
    _codeLine.numberOfLines = 1;

    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setLineNumber:(int)lineNumber
{
    _lineNumber = lineNumber;
    _lineNumberLabel.text = [NSString stringWithFormat:@"%d", _lineNumber];
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
    _lineNumberLabel.frame =
    CGRectMake(0, 0, _lineNumberWidth, self.contentView.bounds.size.height);

    _codeLine.frame =
    CGRectMake(_lineNumberWidth + 10, 0,
               self.contentView.bounds.size.width - _lineNumberWidth - 10,
               self.contentView.bounds.size.height);
    
    [_codeLine sizeToFit];
}

- (UIView*)backgroundView
{
    return nil;
}

@end
