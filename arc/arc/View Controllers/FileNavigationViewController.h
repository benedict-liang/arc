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

//Currently files is considered an array of strings. I'm thinking it would be helpful to pass the filesystem here, as the FileNavigator would need to view the file heirarchy.
-(id)initWithFiles:(NSArray*)files;

// define delegate property
@property (nonatomic, assign) id delegate;

@end
