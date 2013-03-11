//
//  DetailViewController.m
//  FMDBTest
//
//  Created by Benedict Liang on 11/3/13.
//  Copyright (c) 2013 Benedict Liang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setAgeTextField:nil];
    [self setSearchTextField:nil];
    [super viewDidUnload];
}
- (IBAction)insertButtonPressed:(id)sender {
    // Let fmdb do the work
    [_appDelegate.database executeUpdate:@"insert into user(name, age) values(?,?)",
     _nameTextField.text,[NSNumber numberWithInt:[_ageTextField.text intValue]],nil];
}

- (IBAction)processButtonPressed:(id)sender {
    NSFileHandle *file;
    
    file = [NSFileHandle fileHandleForReadingAtPath:@"/Users/benedict/Desktop/FMDB/FMDBTest/FMDBTest/WebServer.java"];
    
    if (file == nil)
        NSLog(@"Failed to open file");
    
    NSString *fh = [NSString stringWithContentsOfFile:@"/Users/benedict/Desktop/FMDB/FMDBTest/FMDBTest/WebServer.java" encoding:NSUTF8StringEncoding error:NULL];
    NSArray *linesArray = [fh componentsSeparatedByString:@"\n"];
    for (int i=0; i<[linesArray count]; i++) {
        [_appDelegate.database executeUpdate:@"insert into fts_test(id, line_number, text_line) values(?,?,?)",
         [NSNumber numberWithInt:(1000+i)],[NSNumber numberWithInt:(i+1)],[linesArray objectAtIndex:i],nil];
    }
    
    [_appDelegate.database commit];
}

- (IBAction)getLineNumberButtonPressed:(id)sender {
    NSString *query = _searchTextField.text;
    FMResultSet *results = [_appDelegate.database executeQuery:@"SELECT * FROM fts_test WHERE text_line MATCH ?;",
                            query];
    while([results next]) {
        NSString *lineNumber = [results stringForColumn:@"line_number"];
        NSLog(@"Line number for query %@: %d", query, [lineNumber intValue]);
    }
}
@end
