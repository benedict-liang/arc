//
//  Utils.m
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
    return [[fileSystemObject1 path] isEqualToString:[fileSystemObject2 path]];
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
@end