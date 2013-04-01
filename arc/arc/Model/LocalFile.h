//
//  LocalFile.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface LocalFile : NSObject <File> {
    NSString *_contents;
    BOOL _needsRefresh;
}

@end
