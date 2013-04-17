//
//  LoadingOverlayViewController.m
//  arc
//
//  Created by Jerome Cheng on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LoadingOverlayViewController.h"

@interface LoadingOverlayViewController ()

@property CGRect frame;
@property UIActivityIndicatorView *spinnerView;
@property UILabel *loadingLabel;
@property UIView *spinnerContainer;

@end

@implementation LoadingOverlayViewController

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        _frame = frame;
        [[self view] setFrame:frame];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [[self view] setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] setAutoresizesSubviews:YES];
    
    _spinnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    
    // Create the "Loading..." label.
    _loadingLabel = [[UILabel alloc] init];
    [_loadingLabel setText:@"Loading..."];
    [_loadingLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [_loadingLabel setTextColor:[UIColor lightGrayColor]];
    
    // Create the spinner.
    _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_spinnerView setHidden:NO];
    
    // Add the elements to the container.
    [_spinnerContainer addSubview:_loadingLabel];
    [_loadingLabel setFrame:CGRectMake(0, 3, 80, 25)];
    [_spinnerContainer addSubview:_spinnerView];
    [_spinnerView setFrame:CGRectMake(80, 0, 30, 30)];

    [[self view] addSubview:_spinnerContainer];
    [_spinnerContainer setCenter:CGPointMake([[self view] bounds].size.width / 2, [[self view] bounds].size.height / 2)];
    [[self view] setBackgroundColor:[UIColor whiteColor]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_spinnerView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
