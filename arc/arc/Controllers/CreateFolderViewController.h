//
//  CreateFolderViewController.h
//  arc
//
//  Created by Jerome Cheng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "CreateFolderViewControllerDelegate.h"

@interface CreateFolderViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<CreateFolderViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<CreateFolderViewControllerDelegate>)delegate;

@end
