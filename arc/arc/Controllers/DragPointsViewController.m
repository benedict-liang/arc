//
//  DragPointsViewController.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointsViewController.h"

@interface DragPointsViewController ()

@end

@implementation DragPointsViewController

- (id)initWithSelectedTextRect:(CGRect)selectedTextRect andOffset:(int)offset {
    self = [super init];
    
    if (self) {
        CGRect leftDragPointFrame = CGRectMake(selectedTextRect.origin.x + offset,
                                               selectedTextRect.origin.y,
                                               20,
                                               selectedTextRect.size.height);
        _leftDragPoint = [[DragPointImageView alloc] initWithFrame:leftDragPointFrame];
        
        CGRect rightDragPointFrame = CGRectMake(selectedTextRect.origin.x + selectedTextRect.size.width + offset,
                                               selectedTextRect.origin.y,
                                               20,
                                               selectedTextRect.size.height);
        _rightDragPoint = [[DragPointImageView alloc] initWithFrame:rightDragPointFrame];
        
        UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(moveLeftDragPoint:)];
        UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(moveRightDragPoint:)];
        
    }
    
    return self;
}

- (void)moveLeftDragPoint:(UIPanGestureRecognizer*)gesture {
    
}

- (void)moveRightDragPoint:(UIPanGestureRecognizer*)gesture {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
