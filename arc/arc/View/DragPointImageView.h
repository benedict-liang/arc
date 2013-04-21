//
//  DragPointImageView.h
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {kLeft, kRight} DragPointType;

@interface DragPointImageView : UIImageView

@property (nonatomic, readonly) DragPointType dragPointType;

- (id)initWithFrame:(CGRect)frame andImageName:(NSString*)imageName;
- (id)initWithFrame:(CGRect)frame andType:(DragPointType)type;

@end
