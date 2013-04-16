//
//  DragPointsViewController.h
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragPointImageView.h"
#import "CodeViewController.h"

@interface DragPointsViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) DragPointImageView *leftDragPoint;
@property (nonatomic, strong) DragPointImageView *rightDragPoint;
@property (nonatomic, strong) NSIndexPath *topIndexPath;
@property (nonatomic, strong) NSIndexPath *bottomIndexPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CodeViewController *codeViewController;
@property (nonatomic) NSRange selectedTextRange;

- (id)initWithSelectedTextRect:(CGRect)selectedTextRect andOffset:(int)offset;
- (id)initWithIndexPath:(NSIndexPath*)indexPath
         withTouchPoint:(CGPoint)touchPoint
              andOffset:(int)offset
           forTableView:(UITableView*)tableView
      andViewController:(UIViewController*)viewController;
@end
