//
//  DestinationFolderViewController.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BasicFolderViewController.h"
#import "FolderCommandObject.h"
#import "PresentingModalViewControllerDelegate.h"
#import "ModalViewControllerDelegate.h"
#import "AddFolderViewController.h"

@interface DestinationFolderViewController : BasicFolderViewController<UITableViewDataSource,
    UITableViewDelegate, ModalViewControllerDelegate, PresentingModalViewControllerDelegate>
@end
