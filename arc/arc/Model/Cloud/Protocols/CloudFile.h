//
//  CloudFile.h
//  arc
//
//  Created by Jerome Cheng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CloudFile <NSObject>

// The name of this file.
@property (strong, nonatomic) NSString *name;

// The identifier of this file within the cloud service.
@property (strong, nonatomic) NSString *identifier;

// The file extension of this file.
@property (strong, nonatomic) NSString *extension;

// The size of this file, in bytes.
@property float size;

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier size:(float)size;

@end
