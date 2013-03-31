//
//  CoreTextUIView.m
//  arc
//
//  Created by Yong Michael on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CoreTextUIView.h"
#import <CoreText/CoreText.h>

@interface CoreTextUIView ()
- (void)updateHeight;
@property CTFramesetterRef frameSetter;
@end

@implementation CoreTextUIView
@synthesize frameSetter = _frameSetter;
@synthesize padding = _padding;
@synthesize attributedString = _attributedString;

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _padding = 20;
    }
    return self;
}


- (void)setAttributedString:(NSAttributedString *)attributedString
{
    // Update Attributed String
    _attributedString = attributedString;
    [self updateFrameSetter];
    [self refresh];
}

- (void)updateFrameSetter
{
    // Release Previous FrameSetter
    if (_frameSetter) {
        CFRelease(_frameSetter);
    }

    // Get a Framesetter to draw the actual text
    _frameSetter = CTFramesetterCreateWithAttributedString(
        (__bridge CFAttributedStringRef)_attributedString);
}

- (void)refresh
{
    [self updateHeight];
    [self setNeedsDisplay];
}

- (void)updateHeight
{
    CFRange stringRange = CFRangeMake(0, _attributedString.string.length);
    float textWidth = self.frame.size.width - 2*_padding;
    
    // Calculate Suggested Size for Text
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
        _frameSetter,
        stringRange,
        NULL,
        CGSizeMake(textWidth, CGFLOAT_MAX),
        NULL);
    
    // Account for padding
    float height = suggestedSize.height + 2*_padding;
    
    // Update frame height
    self.frame = CGRectMake(
        self.frame.origin.x, self.frame.origin.y,
        self.frame.size.width, height);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_attributedString != nil) {
        CFRange stringRange = CFRangeMake(0, _attributedString.string.length);
        float textWidth = self.bounds.size.width - 2*_padding;
        float textHeight = self.bounds.size.height - 2*_padding;

        // Get the graphics context for drawing
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);

        // Flip the coordinate system
        // Coretext uses OSX coordinate system.
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Create TextRectangle
        CGRect textRect = CGRectMake(_padding, _padding, textWidth, textHeight);
        
        // Create a path to draw in and add our textRect to the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, textRect);
        
        // Create Frame from Framesetter and Path
        CTFrameRef frame = CTFramesetterCreateFrame(_frameSetter, stringRange, path, NULL);
        
        // Draw Frame onto Context
        CTFrameDraw(frame, context);
        
        // Release C Objects
        CFRelease(frame);
        CFRelease(path);
        
        // Restore State of the Context
        CGContextRestoreGState(context);
    }
}

@end
