//
//  Utils.h
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
// Taken from http://stackoverflow.com/questions/941604/setting-uiimage-dimensions-on-uitableviewcell-image
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
@end
