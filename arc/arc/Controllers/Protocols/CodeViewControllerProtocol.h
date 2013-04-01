//
//  CodeViewControllerDelegate.h
//  arc
//
//  Created by omer iqbal on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"

@protocol ContentViewControllerProtocol <NSObject>
- (void)mergeAndRenderWith:(ArcAttributedString*)aas;
@end
