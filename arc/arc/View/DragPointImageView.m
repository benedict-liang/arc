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
        CGFloat aspectRatio = dragPointImage.size.width / dragPointImage.size.height;

        CGSize size=CGSizeMake(aspectRatio * frame.size.height, frame.size.height);//set the width and height
        UIGraphicsBeginImageContext(size);
        [dragPointImage drawInRect:CGRectMake(0,0,size.width,size.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        //here is the scaled image which has been changed to the size specified
        UIGraphicsEndImageContext();
        
        self.contentMode = UIViewContentModeCenter;
        
        self.image = newImage;
        self.backgroundColor = [UIColor clearColor];




        
//        self.contentMode = UIViewContentModeScaleAspectFit;
//        UIImage *dragPointImage = [UIImage imageNamed:imageName];
//        self.image = dragPointImage;
//        self.backgroundColor = [UIColor clearColor];
//        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.image.size.width, self.image.size.height);
    }
    return self;
}

@end
