//
//  ViewPickerController.m
//  arc
//
//  Created by Jerome Cheng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewPickerController.h"

@implementation ViewPickerController

- (id)initWithPicker:(UIPickerView *) picker properties:(NSDictionary *)properties delegate:(id<ViewPickerControllerDelegate>)delegate
{
    if (self = [super init]) {
        _picker = picker;
        [_picker setDataSource:self];
        [_picker setDelegate:self];
        [_picker setShowsSelectionIndicator:YES];
        _properties = properties;
        _delegate = delegate;
    }
    return self;
}

#pragma mark Picker Dimensions
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    return 0.9 * [_picker frame].size.width;
}

#pragma mark Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_properties objectForKey:SECTION_OPTIONS] count];
}

#pragma mark Picker Data
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *option = [[_properties objectForKey:SECTION_OPTIONS] objectAtIndex:row];
    return [option objectForKey:PLUGIN_OPTION_LABEL];
}

@end
