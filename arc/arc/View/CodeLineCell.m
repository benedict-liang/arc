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
@property (nonatomic, strong) UILabel *foldingMarker;
@end

@implementation CodeLineCell
@synthesize line = _line;
@synthesize lineNumberWidth = _lineNumberWidth;
@synthesize foldingMarkerWidth = _foldingMarkerWidth;
@synthesize padding = _padding;
@synthesize lineNumber = _lineNumber;
@synthesize showLineNumber = _showLineNumber;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lineNumberWidth = SIZE_CODEVIEW_LINENUMBERS_MIN + SIZE_CODEVIEW_MARGIN_LINENUMBERS;
        _showLineNumber = YES;
        _foldingMarkerWidth = 15;
        _padding = 5;
        _lineNumberLabel = [[UILabel alloc] init];
        _lineNumberLabel.backgroundColor = [UIColor clearColor];
        _lineNumberLabel.textAlignment = NSTextAlignmentRight;
        _lineNumberLabel.numberOfLines = 1;
        [self.contentView addSubview:_lineNumberLabel];

        _codeLine = [[UILabel alloc] init];
        _codeLine.backgroundColor = [UIColor clearColor];
        _codeLine.numberOfLines = 1;
        [self.contentView addSubview:_codeLine];
        
        _foldingMarker = [[UILabel alloc] init];
        _foldingMarker.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_foldingMarker];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setForegroundColor:(UIColor*)foregroundColor
{
    _foregroundColor = foregroundColor;
    _lineNumberLabel.textColor = _foregroundColor;
    _foldingMarker.textColor = _foregroundColor;
}

- (void)setFontFamily:(NSString*)fontFamily FontSize:(int)fontSize
{
    _fontFamily = fontFamily;
    _fontSize = fontSize;
    _lineNumberLabel.font = [UIFont fontWithName:_fontFamily size:_fontSize];
}

- (void)setLine:(NSAttributedString *)line
{
    _line = line;
    _codeLine.attributedText = _line;
    _lineNumberLabel.text = @"";
}

+ (int)calcLineNumberWidthForMaxLineNumber:(int)lineNumber
                                FontFamily:(NSString *)fontFamily
                                  FontSize:(int)fontSize
{
    CGSize textSize = [[NSString stringWithFormat:@"%d", lineNumber]
                       sizeWithFont:[UIFont fontWithName:fontFamily size:fontSize]];
    
    int lineNumberWidth = ceil(textSize.width);

    // min line width 30 with margin = 5
    if (lineNumberWidth < SIZE_CODEVIEW_LINENUMBERS_MIN) {
        lineNumberWidth = SIZE_CODEVIEW_LINENUMBERS_MIN;
    }

    return lineNumberWidth + SIZE_CODEVIEW_MARGIN_LINENUMBERS;
}

- (void)setLineNumber:(int)lineNumber
{
    _lineNumber = lineNumber;
    _lineNumberLabel.text = [NSString stringWithFormat:@"%d", _lineNumber];
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    if (_showLineNumber) {
        _lineNumberLabel.frame =
        CGRectMake(0, 0, _lineNumberWidth, self.contentView.bounds.size.height);
        
        _foldingMarker.frame =
        CGRectMake(_lineNumberWidth, 0, _foldingMarkerWidth, self.contentView.bounds.size.height);

        _codeLine.frame =
        CGRectMake(_lineNumberWidth + _foldingMarkerWidth + SIZE_CODEVIEW_PADDING_LINENUMBERS,
                   0,
                   self.contentView.bounds.size.width - _lineNumberWidth - SIZE_CODEVIEW_PADDING_LINENUMBERS,
                   self.contentView.bounds.size.height);
    } else {
        _foldingMarker.frame =
        CGRectMake(SIZE_CODEVIEW_PADDING_LINENUMBERS, 0, _foldingMarkerWidth, self.contentView.bounds.size.height);
        
        _codeLine.frame =
        CGRectMake(SIZE_CODEVIEW_PADDING_LINENUMBERS + _foldingMarkerWidth,
                   0,
                   self.contentView.bounds.size.width - SIZE_CODEVIEW_PADDING_LINENUMBERS,
                   self.contentView.bounds.size.height);
    }
    [_codeLine sizeToFit];
}


- (void)setFolding
{
    _foldingMarker.text = @"▼";
}

- (void)activeFolding
{
    _foldingMarker.text = @"▶";
}

- (void)clearFolding
{
    _foldingMarker.text = @"";
}

- (UIView *)backgroundView
{
    return nil;
}

@end
