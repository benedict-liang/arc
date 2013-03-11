//
//  DetailViewController.h
//  FMDBTest
//
//  Created by Benedict Liang on 11/3/13.
//  Copyright (c) 2013 Benedict Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate> {
    AppDelegate *_appDelegate;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)insertButtonPressed:(id)sender;
- (IBAction)processButtonPressed:(id)sender;
- (IBAction)getLineNumberButtonPressed:(id)sender;



@end
