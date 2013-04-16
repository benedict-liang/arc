//
//  DownloadHelperDelegate.h
//  arc
//
//  Created by Jerome Cheng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadHelperDelegate <NSObject>

- (void)downloadCompleteForHelper:(id)sender;
- (void)downloadFailedForHelper:(id)sender;

@end
