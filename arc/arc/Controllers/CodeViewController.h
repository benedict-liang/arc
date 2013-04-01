//
//  CodeViewController.h
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerProtocol.h"
#import "CoreTextUIView.h"
#import "CodeView.h"
#import "File.h"
#import "Protocols/CodeViewControllerProtocol.h"
@interface CodeViewController : UIViewController<SubViewControllerProtocol>
@property (nonatomic, strong) CodeView *view;
- (void)showFile:(id<File>)file;
@end
