//
//  AddFolderViewController.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentingModalViewControllerDelegate.h"

@interface AddFolderViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) id<PresentingModalViewControllerDelegate> delegate;
@end
