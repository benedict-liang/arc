//
//  UICodeView.h
//  arc
//
//  Created by Yong Michael on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileObject.h"

@interface UICodeView : UIView
- (void)render:(FileObject*)file;
@end
