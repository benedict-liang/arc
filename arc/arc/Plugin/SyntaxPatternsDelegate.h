//
//  SyntaxPatternsDelegate.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyntaxPatternsDelegate <NSObject>
- (SyntaxMatchStore*)parseResultsForContent:(NSString*)content Range:(NSRange)range;
@property id<SyntaxPatternsDelegate> parent;
- (SyntaxMatchStore*)parseResultsForRepoRule:(NSString*)key
                                     Content:(NSString*)content
                                       Range:(NSRange)range;
@end
