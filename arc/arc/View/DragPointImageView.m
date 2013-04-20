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
        
        if ([imageName isEqualToString:@"leftDragPoint.png"]) {
            
            UIImage *scaledImage = [self scaleImageWithAspectRatio:imageName];
            CGFloat aspectRatio = scaledImage.size.width / scaledImage.size.height;
            CGSize scaledSize = CGSizeMake(aspectRatio * (scaledImage.size.height - 30),
                                           scaledImage.size.height - 30);
            UIGraphicsBeginImageContext(scaledImage.size);
            [scaledImage drawInRect:CGRectMake(0, 0,scaledSize.width,
                                               scaledSize.height)];
            [scaledImage drawInRect:CGRectMake(0, scaledSize.height,
                                               20,
                                               20)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.image = newImage;
            
            self.contentMode = UIViewContentModeTop;
            self.backgroundColor = [UIColor clearColor];
        }
        else {
            UIImage *scaledImage = [self scaleImageWithAspectRatio:imageName];
            self.image = scaledImage;
            
            self.contentMode = UIViewContentModeCenter;
            self.backgroundColor = [UIColor clearColor];
        }
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
