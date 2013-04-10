//
//  SelectionView.h
//  arc
//
//  Created by Benedict Liang on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionView : UIView

@property (nonatomic, strong) NSString *selectedString;
@property (nonatomic, strong) UIView *rightDragPoint;
@property (nonatomic, strong) UIView *leftDragPoint;

- (void)updateSize:(CGSize)updatedSize;

@end
