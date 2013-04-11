//
//  ViewPickerControllerDelegate.h
//  arc
//
//  Created by Jerome Cheng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewPickerControllerDelegate <NSObject>

- (void)pickerSelectedOption:(NSDictionary *)option;

@end
