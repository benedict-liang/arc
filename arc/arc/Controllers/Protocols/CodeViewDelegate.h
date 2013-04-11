//
//  CodeViewDelegate.h
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CodeViewDelegate <NSObject>
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) int fontSize;
@property (nonatomic) BOOL lineNumbers;
@property (nonatomic) BOOL wordWrap;
@end