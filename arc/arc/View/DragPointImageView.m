//
//  DragPointImageView.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointImageView.h"

@implementation DragPointImageView

- (id)initWithFrame:(CGRect)frame andType:(DragPointType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *scaledLineImage = [self scaleImageWithAspectRatio:@"dragpointline.png"];
        CGFloat aspectRatio = scaledLineImage.size.width / scaledLineImage.size.height;
        NSString *circleImageName;
        
        if (type == kRight) {
            
            circleImageName = @"dragpointcirclebottom.png";
            
        }
        else {
            circleImageName = @"dragpointcircletop.png";            
        }
        
        UIImage *circle = [UIImage imageNamed:circleImageName];
        CGSize newDragPointSize = CGSizeMake(circle.size.width,
                                    scaledLineImage.size.height);
        
        CGSize newLineSize = CGSizeMake(aspectRatio * (scaledLineImage.size.height - circle.size.height),
                                       scaledLineImage.size.height - circle.size.height);
        
        // Draw new drag point image
        UIGraphicsBeginImageContext(newDragPointSize);
        [scaledLineImage drawInRect:CGRectMake(newDragPointSize.width / 2 - scaledLineImage.size.width / 2,
                                               0,
                                               newLineSize.width,
                                               newLineSize.height)];
        [circle drawInRect:CGRectMake(0, newLineSize.height,
                                      circle.size.width,
                                      circle.size.height)];
        UIImage* newDragPointImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        self.image = newDragPointImage;
        self.contentMode = UIViewContentModeTop;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImageName:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *scaledImage = [self scaleImageWithAspectRatio:imageName];
        self.image = scaledImage;
        
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (UIImage *)scaleImageWithAspectRatio:(NSString *)imageName
{
    CGRect frame = self.frame;
    
    UIImage *dragPointImage = [UIImage imageNamed:imageName];
    CGFloat aspectRatio = dragPointImage.size.width / dragPointImage.size.height;
    CGSize scaledSize = CGSizeMake(aspectRatio * frame.size.height,
                                   frame.size.height);
    
    UIGraphicsBeginImageContext(scaledSize);
    [dragPointImage drawInRect:CGRectMake(0,0,scaledSize.width,
                                          scaledSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
