//
//  CodeLineCell.h
//  arc
//
//  Created by Yong Michael on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CodeLineCell : UITableViewCell
@property (nonatomic) CTLineRef line;
@end
