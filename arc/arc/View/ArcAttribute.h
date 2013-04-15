//
//  ArcAttribute.h
//  arc
//
//  Created by Yong Michael on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcAttribute : NSObject
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) NSString *type;
- (id) initWithType:(NSString *)type withValue:(id)value onRange:(NSRange)range;
@end
