//
//  AddFolderViewController.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AddFolderViewController.h"

@interface AddFolderViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation AddFolderViewController
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Create a Folder";
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(cancel:)];
    
    UIBarButtonItem *createFolder =
    [[UIBarButtonItem alloc] initWithTitle:@"Create Folder"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(createFolder:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = createFolder;
    
    UIView *container = [[UIView alloc] init];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    container.backgroundColor = [UIColor whiteColor];
    container.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 50);
    [self.view addSubview:container];
    
    _textField = [[UITextField alloc]
                  initWithFrame:CGRectMake(10, 10, floorf((container.frame.size.width - 20)/2), 30)];
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.font = [UIFont fontWithName:[UI fontName] size:20];
    _textField.textColor = [UIColor blackColor];
    _textField.placeholder = @"Untitled Folder";
    _textField.keyboardType = UIKeyboardTypeAlphabet;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.enabled = YES;
    _textField.delegate = self;
    [container addSubview:_textField];

    [_textField becomeFirstResponder];
}

- (void)cancel:(id)sender
{
    [self.delegate modalViewControllerDone:
     [FolderCommandObject commandOfType:kCancelCommand
                             withTarget:nil]];
}

- (BOOL)textFieldShouldReturn:(id)sender
{
    if ([sender isEqual:_textField]) {
        [_textField resignFirstResponder];
        [self createFolder:nil];
        return NO;
    }

    return YES;
}

- (void)createFolder:(id)sender
{
    if ([_textField text].length != 0) {
        [self.delegate modalViewControllerDone:
         [FolderCommandObject commandOfType:kCreateFolderCommand
                                 withTarget:[_textField text]]];
    } else {
        [_textField becomeFirstResponder];
    }
}

@end
