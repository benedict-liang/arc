//
//  arcTests.m
//  arcTests
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "arcTests.h"
#import "Constants.h"

@implementation arcTests


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _rootFolder = [RootFolder getInstance];
    
    for (FileObject *current in [_rootFolder getContents]) {
        if (![[current name] isEqualToString:FOLDER_EXTERNAL_APPLICATIONS]) {
            [current remove];
        }
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
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
            break;
        }
    }
    
    NSString *retrievedName = [retrieved name];
    NSString *retrievedContents = [retrieved getContents];
    
    STAssertNotNil(retrieved, @"File is persisted and retrievable.");
    STAssertTrue([testFileName isEqualToString:retrievedName], @"File name is persisted.");
    STAssertTrue([testFileContents isEqualToString:retrievedContents], @"File contents are persisted.");
}

- (void)testCreateFolder
{
    NSString *testFolderName = @"Test Folder";
    
    [_rootFolder createFolder:testFolderName];
    
    NSArray *rootContents = [_rootFolder getContents];
    int expected = 2;
    int actual = [rootContents count];
    STAssertEquals(expected, actual, @"Root folder contains 2 objects");
    
    Folder *retrieved;
    for (FileObject *currentObject in rootContents) {
        if ([currentObject isKindOfClass:[Folder class]] && [[currentObject name] isEqualToString:testFolderName]) {
            retrieved = (Folder*)currentObject;
            break;
        }
    }
    
    NSString *retrievedName = [retrieved name];
    
    STAssertNotNil(retrieved, @"Folder is persisted and retrievable.");
    STAssertTrue([testFolderName isEqualToString:retrievedName], @"Folder name is persisted.");
}

@end
