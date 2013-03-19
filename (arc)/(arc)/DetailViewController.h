//
//  DetailViewController.h
//  (arc)
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 Benedict Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
