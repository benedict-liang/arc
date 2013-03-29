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
}

- (void)tearDown
{
    // Tear-down code here.
    for (FileObject *current in [_rootFolder contents]) {
        if (![[current name] isEqualToString:FOLDER_EXTERNAL_APPLICATIONS]) {
            [current remove];
        }
    }
    
    [super tearDown];
}

- (void)testCreateFiles
{
    NSString *testFileName = @"test.txt";
    NSString *testFileContents = @"This is a test.";
    
    [File fileWithName:testFileName Contents:testFileContents inFolder:_rootFolder];
    
    NSArray *rootContents = [_rootFolder contents];
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
    NSString *retrievedContents = [retrieved contents];
    
    STAssertNotNil(retrieved, @"File is persisted and retrievable.");
    STAssertTrue([testFileName isEqualToString:retrievedName], @"File name is persisted.");
    STAssertTrue([testFileContents isEqualToString:retrievedContents], @"File contents are persisted.");
}

- (void)testCreateFolder
{
    NSString *testFolderName = @"Test Folder";
    
    [_rootFolder createFolder:testFolderName];
    
    NSArray *rootContents = [_rootFolder contents];
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

- (void)testRenameFolder
{
    NSString *testFolderName = @"Test Folder";
    [_rootFolder createFolder:testFolderName];
    
    NSArray *rootContents = [_rootFolder contents];
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
    
    NSString *renamedName = @"Renamed";
    [retrieved rename:renamedName];
    NSString *renamedObjectName = [retrieved name];
    STAssertTrue([renamedObjectName isEqualToString:renamedName], @"Folder is renamed successfully.");

    rootContents = [_rootFolder contents];
    for (FileObject *currentObject in rootContents) {
        if ([currentObject isKindOfClass:[Folder class]] && [[currentObject name] isEqualToString:testFolderName]) {
            retrieved = (Folder*)currentObject;
            break;
        }
    }
    NSString *retrievedName = [retrieved name];
    STAssertTrue([retrievedName isEqualToString:renamedName], @"Folder rename is persisted.");
}

- (void)testRemove
{
    NSString *testFolderName = @"This Will Be Deleted!";
    [_rootFolder createFolder:testFolderName];
    
    Folder *folderDeletionTarget = (Folder*)[_rootFolder retrieveObjectWithName:testFolderName];
    STAssertTrue([folderDeletionTarget remove], @"Folder deletion returns YES.");
    
    NSString *testFileName = @"delete.txt";
    File *fileDeletionTarget = [File fileWithName:testFileName Contents:testFolderName inFolder:_rootFolder];
    STAssertTrue([fileDeletionTarget remove], @"File deletion returns YES.");
    
    NSArray *rootContents = [_rootFolder contents];
    int expected = 1;
    int actual = [rootContents count];
    STAssertEquals(expected, actual, @"Root folder has only the External Applications folder in it.");
}

@end
