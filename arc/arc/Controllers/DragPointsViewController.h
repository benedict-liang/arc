//
//  DragPointsViewController.h
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragPointImageView.h"

@interface DragPointsViewController : UIViewController

- (id)initWithSelectedTextRect:(CGRect)selectedTextRect andOffset:(int)offset;

@property (nonatomic, strong) DragPointImageView *leftDragPoint;
@property (nonatomic, strong) DragPointImageView *rightDragPoint;

@end
