//
//  CodeFolding.h
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoldNode.h"
#import "FoldTree.h"

@interface CodeFolding : NSObject
+(FoldTree*)foldTreeForContent:(NSString*)content
                     foldStart:(NSString*)fs
                       foldEnd:(NSString*)fe
                    skipRanges:(NSArray*)skips;
@end
