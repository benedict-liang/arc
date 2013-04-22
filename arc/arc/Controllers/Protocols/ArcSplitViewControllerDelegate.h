//
//  ArcSplitViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArcSplitViewControllerDelegate <NSObject>
@optional
- (void)willShowMasterViewAnimated:(BOOL)animate;

@optional
- (void)willHideMasterViewAnimated:(BOOL)animate;

@optional
- (void)didShowMasterViewAnimated:(BOOL)animate boundsChanged:(BOOL)boundsChanged;

@optional
- (void)didHideMasterViewAnimated:(BOOL)animate boundsChanged:(BOOL)boundsChanged;

@end
