//
//  SyntaxItemProtocol.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyntaxItemProtocol <NSObject>
@optional
@property NSString* name;
@property NSArray* capturableScopes;
@end
