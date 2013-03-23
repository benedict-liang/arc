//
//  arcTests.m
//  arcTests
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "arcTests.h"

@implementation arcTests


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _rootFolder = [RootFolder getInstance];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    for (FileObject *current in [_rootFolder getContents]) {
        [current remove];
    }
}

- (void)testCreateFiles
{
    File *test = [File fileWithName:@"test.txt" Contents:@"This is a test" inFolder:_rootFolder];
    File *test2 = [File fileWithName:@"anotherTest.c" Contents:@"Hello world!"inFolder:_rootFolder];
    File *test3 = [File fileWithName:@"and_another.test" Contents:@"Does this thing work?" inFolder:_rootFolder];
    
    NSArray *rootContents = [_rootFolder getContents];
    int expected = 4;
    int actual = [rootContents count];
    STAssertEquals(expected, actual, @"Root folder contains 4 objects");
}

@end
