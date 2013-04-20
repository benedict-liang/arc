//
//  CodeLineCell.h
//  arc
//
//  Created by Yong Michael on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CodeLineCell : UITableViewCell
@property (nonatomic, strong) NSAttributedString *line;
@property (nonatomic, strong) UILabel *lineNumberLabel;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) BOOL showLineNumber;
@property (nonatomic) BOOL foldStart;
@property (nonatomic) int lineNumberWidth;
@property (nonatomic) int lineNumber;
@property (nonatomic) NSRange stringRange;

+ (int)calcLineNumberWidthForMaxLineNumber:(int)lineNumber
                                FontFamily:(NSString *)fontFamily
                                  FontSize:(int)fontSize;

- (void)setForegroundColor:(UIColor*)foregroundColor;
- (void)setFontFamily:(NSString*)fontFamily FontSize:(int)fontSize;

- (void)highlight;
- (void)removeHighlight;
- (void)resetCell;
@end
