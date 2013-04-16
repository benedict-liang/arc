//
//  Utils.h
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemObject.h"

@interface Utils : NSObject
// Taken from http://stackoverflow.com/questions/941604/setting-uiimage-dimensions-on-uitableviewcell-image
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

// Taken from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorFromRGB:(int)rgbValue;

+ (BOOL)isEqual:(id<FileSystemObject>)fileSystemObject1 and:(id<FileSystemObject>)fileSystemObject2;

+ (UIBarButtonItem *)flexibleSpace;

+ (NSString *)humanReadableFileSize:(float)fileSize;

+ (NSArray*)sortRanges:(NSArray*)ranges;

+ (BOOL)isSubsetOf:(NSRange)ro arg:(NSRange)ri;

+ (BOOL)isIntersectingWith:(NSRange)r1 And:(NSRange)r2;

+ (NSArray*)rangeDifferenceBetween:(NSRange)r1 And:(NSRange)r2;

+ (BOOL)isContainedByRange:(NSRange)range Index:(CFIndex)index;

+ (NSDictionary*)rangeArrayToDict:(NSArray*)array;

+ (BOOL)range:(NSRange)checkRange isSubsetOfRangeInArray:(NSArray *)ranges;

+ (UIImage *)imageSized:(CGRect)rect withColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
