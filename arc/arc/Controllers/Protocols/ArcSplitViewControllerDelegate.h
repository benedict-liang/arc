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
- (void)didResizeSubViewsBoundsChanged:(BOOL)boundsChanged;

@optional
- (void)willShowMasterViewAnimated:(BOOL)animate;

@optional
- (void)willHideMasterViewAnimated:(BOOL)animate;
@end
