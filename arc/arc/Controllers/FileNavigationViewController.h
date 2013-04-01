//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "SubViewControllerProtocol.h"

@interface FileNavigationViewController : UIViewController <SubViewControllerProtocol, UITableViewDelegate, UITableViewDataSource>
- (id)initWithFolder:(id<Folder>)folder;
@end
