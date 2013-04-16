//
//  DragPointImageView.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointImageView.h"

@implementation DragPointImageView

- (id)initWithFrame:(CGRect)frame andImageName:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *dragPointImage = [UIImage imageNamed:imageName];
        self.image = dragPointImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
