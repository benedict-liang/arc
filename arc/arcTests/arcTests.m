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
    NSString *testFileName = @"test.txt";
    NSString *testFileContents = @"This is a test.";
    
    [File fileWithName:testFileName Contents:testFileContents inFolder:_rootFolder];
    
    NSArray *rootContents = [_rootFolder getContents];
    int expected = 2;
    int actual = [rootContents count];
    STAssertEquals(expected, actual, @"Root folder contains 2 objects");
    
    File *retrieved;
    for (FileObject *currentObject in rootContents) {
        if ([currentObject isKindOfClass:[File class]]) {
            retrieved = (File*)currentObject;
        }
    }
    STAssertTrue([testFileName isEqualToString:[retrieved name]], @"File name is persisted.");
    STAssertTrue([testFileContents isEqualToString:[retrieved getContents]], @"File contents are persisted.");
}

@end
