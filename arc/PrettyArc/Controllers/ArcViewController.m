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
	// Do any additional setup after loading the view.
    _left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.width)];
    _left.layer.cornerRadius = 7;
    _left.layer.masksToBounds = YES;
    _left.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_left];
    

    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(320, 0, self.view.bounds.size.height - 320, self.view.bounds.size.width)];
    right.layer.cornerRadius = 7;
    right.layer.masksToBounds = NO;
    right.backgroundColor = [UIColor whiteColor];
    right.layer.shadowRadius = 5;
    right.layer.shadowOpacity = 0.5;
    [self.view addSubview:right];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [right addGestureRecognizer:pan];
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

# pragma mark - Orientation Methods

- (BOOL)shouldAutorotate
{
    // Allow any orientation
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
    } else {
        
    }
}

@end
