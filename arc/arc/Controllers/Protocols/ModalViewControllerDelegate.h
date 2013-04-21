//
//  ModalViewControllerDelegate.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PresentingModalViewControllerDelegate;

@protocol ModalViewControllerDelegate <NSObject>
@property (nonatomic, weak) id<PresentingModalViewControllerDelegate> delegate;
@end