//
//  ArcSplitViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArcSplitViewControllerDelegate <NSObject>
- (void)resizeSubViewsBoundsChanged:(BOOL)boundsChanged;
@end
