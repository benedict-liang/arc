//
//  SyntaxHighlightDelegate.h
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyntaxHighlightDelegate <NSObject>
@optional
-(void)testFoldsOnFoldRanges:(NSArray*)fR
                  foldStarts:(NSArray*)fS
                    foldEnds:(NSArray*)fE;
@end
