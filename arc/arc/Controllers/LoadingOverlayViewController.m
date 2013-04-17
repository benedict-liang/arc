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
    
    _spinnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    [_spinnerContainer setCenter:CGPointMake(_frame.size.width / 2, _frame.size.height / 2)];
    
    // Create the "Loading..." label.
    _loadingLabel = [[UILabel alloc] init];
    [_loadingLabel setText:@"Loading..."];
    [_loadingLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [_loadingLabel setTextColor:[UIColor lightGrayColor]];
    [_loadingLabel setFrame:CGRectMake(0, 3, 70, 25)];
    
    // Create the spinner.
    _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_spinnerView setFrame:CGRectMake(80, 0, 30, 30)];
    
    // Add the elements to the container.
    [_spinnerContainer addSubview:_loadingLabel];
    [_spinnerContainer addSubview:_spinnerView];
    
    [[self view] addSubview:_spinnerContainer];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_spinnerView startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_spinnerView stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
