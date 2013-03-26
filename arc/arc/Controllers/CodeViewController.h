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
#import "File.h"

@interface CodeViewController : UIViewController<SubViewController>
@property (nonatomic, strong) CoreTextUIView *view;

// Loads File
- (void)showFile:(File*)file;
@end
