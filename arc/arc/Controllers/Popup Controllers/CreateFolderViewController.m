//
//  CreateFolderViewController.m
//  arc
//
//  Created by Jerome Cheng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CreateFolderViewController.h"

@interface CreateFolderViewController ()

@property UITextField *textField;
@property UIButton *okButton;


@end

@implementation CreateFolderViewController

- (id)initWithDelegate:(id<CreateFolderViewControllerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 119)];
}

- (void)okButtonPressed
{
    [self textFieldShouldReturn:_textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *input = [_textField text];
    [_textField setText:@""];
    [_delegate createFolderWithName:input];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setContentSizeForViewInPopover:self.view.frame.size];
    
    UILabel *createFolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 238, 25)];
    [createFolderLabel setText:@"Enter folder name:"];
    [createFolderLabel setFont:[UIFont boldSystemFontOfSize:17]];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(6, 37, 238, 25)];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setDelegate:self];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_okButton setTitle:@"OK" forState:UIControlStateNormal];
    [_okButton setFrame:CGRectMake(6, 68, 238, 45)];
    [_okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    [[self view] addSubview:createFolderLabel];
    [[self view] addSubview:_textField];
    [[self view] addSubview:_okButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
