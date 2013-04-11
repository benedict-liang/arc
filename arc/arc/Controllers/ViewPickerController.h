//
//  ViewPickerController.h
//  arc
//
//  Created by Jerome Cheng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewPickerControllerDelegate.h"
#import "PluginDelegate.h"

@interface ViewPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSDictionary *properties;
@property (weak, nonatomic) id<ViewPickerControllerDelegate> delegate;

- (id)initWithPicker:(UIPickerView *)picker properties:(NSDictionary *)properties delegate:(id<ViewPickerControllerDelegate>)delegate;

@end
