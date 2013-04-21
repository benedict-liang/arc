//
//  UI.m
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UI.h"

@implementation UI
+ (void)exec
{
    [UI navigationBarAppearance];
    [UI barButtonItemAppearance];
    [UI toolBarAppearance];
}

+ (void)navigationBarAppearance
{
    [[UINavigationBar appearance] setBackgroundImage: [Utils imageWithColor:
                                                       [Utils colorWithHexString:@"272821"]]
                                       forBarMetrics:UIBarMetricsDefault];
    // NavBar title
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0 green:0 blue:0 alpha:0], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica Neue" size:0.0], UITextAttributeFont,
                                                          nil]];
}

+ (void)barButtonItemAppearance
{
    [[UIBarButtonItem appearance] setBackgroundImage:[Utils imageWithColor:[Utils colorWithHexString:@"151512"]]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    // NavBar button titles
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0 green:0 blue:0 alpha:0], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica Neue" size:0.0], UITextAttributeFont,
                                                          nil]
                                                forState:UIControlStateNormal];
    
    // TODO
    // make back button arrow shaped.
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[Utils imageSized:CGRectMake(0, 0, 36, 36)
                                                                        withColor:[Utils colorWithHexString:@"151512"]]
                                                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}

+ (void)toolBarAppearance
{
    [[UIToolbar appearance] setBackgroundImage:[Utils imageWithColor:
                                                [Utils colorWithHexString:@"191919"]]
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
}

@end
