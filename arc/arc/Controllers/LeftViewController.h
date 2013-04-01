//
//  LeftBarViewController.h
//  arc
//
//  Created by omer iqbal on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerProtocol.h"
#import "LeftViewControllerProtocol.h"
@interface LeftViewController : UIViewController<SubViewControllerProtocol, LeftViewControllerProtocol>
@end
