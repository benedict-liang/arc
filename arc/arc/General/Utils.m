//
//  Utils.m
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation Utils
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIColor *)colorFromRGB:(int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString*)string
                        start:(NSUInteger)start
                       length:(NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (BOOL)isEqual:(id<FileSystemObject>)fileSystemObject1
            and:(id<FileSystemObject>)fileSystemObject2
{
    return [[fileSystemObject1 identifier] isEqualToString:[fileSystemObject2 identifier]];
}

+ (UIBarButtonItem *)flexibleSpace
{
    return [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
}

+ (NSString *)humanReadableFileSize:(float)fileSize
{
        int divisions = 0;
        NSArray *prefixes = [NSArray arrayWithObjects:
            @"B", @"KB", @"MB", @"GB", @"TB", @"PB", nil];
        while (fileSize > 1024 &&
            divisions < [prefixes count]) {
            fileSize /= 1024.0;
            divisions++;
        }

        // Special Case
        // 1.0, 2.0 (whole numbers)
        if (fileSize == floorf(fileSize)){
            return [NSString stringWithFormat:
                    @"%.0f%@", fileSize, [prefixes objectAtIndex:divisions]];
        }
    
        return [NSString stringWithFormat:
            @"%.1f%@", fileSize, [prefixes objectAtIndex:divisions]];
}


+ (NSArray*)sortRanges:(NSArray*)ranges {
    //ASSUMES: ranges are either non intersecting, or subsets
    //Above holds true for foldable code blocks
    NSMutableArray* sortedRanges = [NSMutableArray arrayWithArray:ranges];
    [sortedRanges sortUsingComparator:^NSComparisonResult(NSValue* v1, NSValue* v2){
        NSRange r1;
        NSRange r2;
        [v1 getValue:&r1];
        [v2 getValue:&r2];
        int r1Ends = r1.location + r1.length;
        int r2Ends = r2.location + r2.length;
        //r1 dominates
        if (r1.location < r2.location && r1Ends > r2Ends) {
            return NSOrderedAscending;
            //r2 dominates
        } else if (r1.location > r2.location && r1Ends < r2Ends) {
            return NSOrderedDescending;
        } else {
            //don't care about other cases
            return NSOrderedSame;
        }
    }];
    return sortedRanges;
}
+ (BOOL)isSubsetOf:(NSRange)ro arg:(NSRange)ri {
    return ro.location <= ri.location && (ro.location+ro.length) >= (ri.location+ri.length);
}

+ (BOOL)isIntersectingWith:(NSRange)r1 And:(NSRange)r2 {
    return (r1.location <= (r2.location + r2.length) && (r1.location + r2.length) >= r2.location) ||
    (r2.location <= (r1.location + r1.length) && (r2.location + r2.length) >= r1.location);
}

+ (NSRange)maxRangeByLocation:(NSRange)r1 And:(NSRange)r2 {
    if (r1.location > r2.location) {
        return r1;
    } else {
        return r2;
    }
}
// returns a range of r1 - intersection(r1,r2) .
// returns nil if r1 is a subset of r2
+ (NSArray*)rangeDifferenceBetween:(NSRange)r1 And:(NSRange)r2 {
    if ([Utils isSubsetOf:r1 arg:r2]) {
        
        NSRange res1 = NSMakeRange(r1.location, r2.location - r1.location);
        int nextBegin = r2.location + r2.length+1;
        NSRange res2 = NSMakeRange(nextBegin, r1.location + r1.length - nextBegin);
        return @[NSStringFromRange(res1),
                 NSStringFromRange(res2)];
    }
    if ([Utils isSubsetOf:r2 arg:r1]) {
        return nil;
    }
    if ([Utils isIntersectingWith:r1 And:r2]) {
        if (r1.location > r2.location) {
            int newR1Start = r2.location+r2.length+1;
            NSRange res = NSMakeRange(newR1Start, r1.location + r1.length - newR1Start);
            return @[NSStringFromRange(res)];
        } else {
            int newR1End = r2.location - 1;
            NSRange res = NSMakeRange(r1.location, newR1End - r1.location);
            return @[NSStringFromRange(res)];
        }
    } else {
        return @[NSStringFromRange(r1)];
    }
}

+ (BOOL)isLightColor:(UIColor *)color
{
    CGFloat hue = 0;
    CGFloat brightness = 0;
    CGFloat saturation = 0;
    CGFloat alpha = 0;
    
    [color getHue:&hue
       saturation:&saturation
       brightness:&brightness
            alpha:&alpha];
    
    return brightness > 0.5;
}

+ (UIColor *)darkenColor:(UIColor *)oldColor percentOfOriginal:(float)amount
{
    float percentage      = amount / 100.0;
    int   totalComponents = CGColorGetNumberOfComponents(oldColor.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(oldColor.CGColor);
    CGFloat newComponents[4];
    
    if (isGreyscale) {
        newComponents[0] = oldComponents[0]*percentage;
        newComponents[1] = oldComponents[0]*percentage;
        newComponents[2] = oldComponents[0]*percentage;
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]*percentage;
        newComponents[1] = oldComponents[1]*percentage;
        newComponents[2] = oldComponents[2]*percentage;
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
    return retColor;
}

+ (UIColor *)lightenColor:(UIColor *)oldColor byPercentage:(float)amount
{
    float percentage      = amount / 100.0;
    int   totalComponents = CGColorGetNumberOfComponents(oldColor.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(oldColor.CGColor);
    CGFloat newComponents[4];
    
    // FIXME: Clean this SHITE up
    if (isGreyscale) {
        newComponents[0] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[1] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[2] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[3] = oldComponents[0]*percentage + oldComponents[1] > 1.0 ? 1.0 : oldComponents[1]*percentage + oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[1] = oldComponents[1]*percentage + oldComponents[1] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[1];
        newComponents[2] = oldComponents[2]*percentage + oldComponents[2] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[2];
        newComponents[3] = oldComponents[3]*percentage + oldComponents[3] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
    return retColor;
}

+ (BOOL)isContainedByRange:(NSRange)range Index:(CFIndex)index
{
    return range.location <= index && index <= (range.location + range.length);
}

+ (UIImage *)imageSized:(CGRect)rect withColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    return [[self class] imageSized:rect withColor:color];
}

+ (NSArray*)filterArray:(NSArray*)array With:(BOOL (^)(id))predicate {
    NSMutableArray* res = [NSMutableArray array];
    for (id elem in array) {
        if (predicate(elem)) {
            [res addObject:elem];
        }
    }
    return res;
}

+ (NSDictionary*)rangeArrayToDict:(NSArray*)array
{
    NSMutableDictionary* res = [NSMutableDictionary dictionary];
    for (NSValue* value in array) {
        NSRange range;
        [value getValue:&range];
        [res setObject:value forKey:NSStringFromRange(range)];
    }
    return res;
}

+ (BOOL)range:(NSRange)checkRange isSubsetOfRangeInArray:(NSArray *)ranges
{
    BOOL flag = NO;
    for (NSValue* v in ranges) {
        NSRange range;
        [v getValue:&range];
        flag = flag || [Utils isSubsetOf:range arg:checkRange];
    }
    return flag;
}

+ (NSRange)rangeFromValue:(NSValue *)value
{
    NSRange range;
    [value getValue:&range];
    return range;
}

+ (NSValue*)valueFromRange:(NSRange)range
{
    return [NSValue value:&range withObjCType:@encode(NSRange)];
}

+ (void)removeAllGestureRecognizersFrom:(UIView *)view
{
    for (UIGestureRecognizer *g in [view gestureRecognizers]) {
        [view removeGestureRecognizer:g];
    }
}

+ (BOOL)isFileSupported:(NSString *)name
{
    NSString *uti = CFBridgingRelease(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)([name pathExtension]), NULL));
    NSString *ourUTI = @"com.nus.arc.source";

    BOOL isOurUTI = UTTypeConformsTo((__bridge CFStringRef)uti, (__bridge CFStringRef)ourUTI);
    BOOL isText = UTTypeConformsTo((__bridge CFStringRef)(uti), (__bridge CFStringRef)@"public.text");
    BOOL isPlainText = UTTypeConformsTo((__bridge CFStringRef)(uti), (__bridge CFStringRef)@"public.plain-text");
    BOOL isSource = UTTypeConformsTo((__bridge CFStringRef)(uti), (__bridge CFStringRef)@"public.source-code");
    
    return isOurUTI || isText || isPlainText || isSource;
}

+ (void)showUnsupportedFileDialog
{
    [[[UIAlertView alloc] initWithTitle:@"Unsupported File" message:@"Sorry, (arc) doesn't support this file type." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

@end