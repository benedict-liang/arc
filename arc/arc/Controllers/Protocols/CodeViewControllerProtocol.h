//
//  CodeViewControllerDelegate.h
//  arc
//
//  Created by omer iqbal on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "File.h"

@protocol CodeViewControllerProtocol <NSObject>
- (void)showFile:(id<File>)file;
- (void)mergeAndRenderWith:(ArcAttributedString*)aas forFile:(id<File>)file;;

@end

