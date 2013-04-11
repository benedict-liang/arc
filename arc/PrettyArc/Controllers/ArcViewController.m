//
//  ArcViewController.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ArcViewController.h"
#import "ArcShadowView.h"

@interface ArcViewController ()
@property BOOL animating;
@property UIView *left;
@property UIView *right;
@end

@implementation ArcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Work Around
    // iOS initial frame is unreliable.
    [[UIApplication sharedApplication]
     setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
	// Do any additional setup after loading the view.
    _left = [[UIView alloc] init];
    _left.layer.cornerRadius = 7;
    _left.layer.masksToBounds = YES;
    // 031f39
    _left.backgroundColor = [UIColor colorWithRed:3/255.0f green:31/255.0f blue:57/255.0f alpha:1];
    [self.view addSubview:_left];

    _right = [[UIView alloc] init];
    _right.layer.cornerRadius = 7;
    _right.layer.masksToBounds = NO;
    _right.backgroundColor = [UIColor whiteColor];
    _right.layer.shadowRadius = 5;
    _right.layer.shadowOpacity = 0.5;
    [self.view addSubview:_right];
    
    [self autoLayout:[[UIApplication sharedApplication]statusBarOrientation]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_right addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (_animating) {
        return;
    }
    
    if ([gesture state] == UIGestureRecognizerStateBegan ||
        [gesture state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation =
        [gesture translationInView:[gesture.view superview]];
        
        UIView *v = gesture.view;
        CGFloat dist = v.frame.origin.x + translation.x;

        if (dist > 320) {
            dist = 320;
        } else if (dist < 0) {
            dist = 0;
        }
        
        [self back:dist];
        
        v.frame = CGRectMake(dist, 0,
                             v.frame.size.width, v.frame.size.height);
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        [UIView beginAnimations:@"slide" context:nil];
        
        _animating = YES;
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (gesture.view.frame.origin.x > 160) {
                                 gesture.view.frame = CGRectMake(320, 0,
                                                                 gesture.view.frame.size.width,
                                                                 gesture.view.frame.size.height);
                                 _left.transform = CGAffineTransformMakeScale(1, 1);
                             } else {
                                 gesture.view.frame = CGRectMake(0, 0,
                                                                 gesture.view.frame.size.width,
                                                                 gesture.view.frame.size.height);
                                 _left.transform = CGAffineTransformMakeScale(0.9, 0.9);
                             }
                         } completion:^(BOOL finished){
                             _animating = NO;
                         }];
    }
}

- (void)back:(CGFloat)dist
{
    CGFloat scale = 0.9 + powf((dist/320.0),2) * 0.1;
    _left.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)autoLayout:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    _left.frame =
    CGRectMake(0, 0, 320, self.view.bounds.size.height);
    
    _right.frame =
    CGRectMake(320, 0, self.view.bounds.size.width - 320, self.view.bounds.size.height);
}

# pragma mark - Orientation Methods

- (BOOL)shouldAutorotate
{
    // Allow any orientation
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self autoLayout:toInterfaceOrientation];
}

@end
