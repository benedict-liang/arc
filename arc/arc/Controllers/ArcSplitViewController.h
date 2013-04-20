//
//  ArcSplitViewController.h
//  arc
//
//  Created by Yong Michael on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcSplitViewController : UIViewController
@property (nonatomic, strong) UIViewController *masterViewController;
@property (nonatomic, strong) UIViewController *detailViewController;
@property (nonatomic, readonly) BOOL masterViewVisible;
- (void)showMasterView;
- (void)hideMasterView;
@end
