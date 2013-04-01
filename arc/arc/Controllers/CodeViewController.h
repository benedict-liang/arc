//
//  CodeViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewController.h"
#import "CoreTextUIView.h"
#import "CodeView.h"
#import "File.h"

@interface CodeViewController : UIViewController<SubViewController>
@property (nonatomic, strong) CodeView *view;
- (void)showFile:(id<File>)file;
@end
