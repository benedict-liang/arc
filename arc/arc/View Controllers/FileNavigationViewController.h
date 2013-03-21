//
//  UIFileNavigationController.h
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileNavigationViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) NSArray* data;
-(id)initWithFiles:(NSArray*)files;

@end
