//
//  ArcSplitViewController.h
//  arc
//
//  Created by Yong Michael on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcSplitViewControllerDelegate.h"

@interface ArcSplitViewController : UIViewController
@property (nonatomic, weak) id<ArcSplitViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *masterView;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, readonly) BOOL masterViewVisible;
- (void)showMasterViewAnimated:(BOOL)animate;
- (void)hideMasterViewAnimated:(BOOL)animate;
@end
