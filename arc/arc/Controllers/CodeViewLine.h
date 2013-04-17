//
//  CodeViewLine.h
//  arc
//
//  Created by Yong Michael on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeViewLine : NSObject
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) BOOL lineStart;
@property (nonatomic, readonly) NSUInteger lineNumber;
- (id)initWithRange:(NSRange)range;
- (id)initWithRange:(NSRange)range AndLineNumber:(NSUInteger)lineNumber;
@end
