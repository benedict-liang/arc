//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileNavigationViewController.h"
#import "RootFolder.h"
#import "File.h"
#import "Folder.h"

@interface FileNavigationViewController ()
@property Folder *currentFolder;
@property UITableView *tableView;
@property NSArray *filesAndFolders;
@end

@implementation FileNavigationViewController
@synthesize delegate;
@synthesize tableView = _tableView;
@synthesize currentFolder = _currentFolder;
@synthesize filesAndFolders = _filesAndFolders;

- (id)init
{
    self = [super init];
    if (self) {
        // tmp.
        _currentFolder = [RootFolder sharedRootFolder];
        _filesAndFolders = (NSArray*)[_currentFolder contents];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;

    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)showFolder:(Folder *)folder
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filesAndFolders count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"FileAndFolderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    
    
    FileObject *fileObject = [_filesAndFolders objectAtIndex:indexPath.row];
    
    if ([fileObject isKindOfClass:[File class]]) {
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
        
    } else if ([fileObject isKindOfClass:[Folder class]]) {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }
    
    cell.textLabel.text = fileObject.name;
    
    return cell;
}
#pragma mark - Table view delegate

//TODO implement protocol to send selected result back to MainView VC

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([[self.data objectAtIndex:indexPath.row] isKindOfClass:[Folder class]]) {
//        
//        // navigation logic
//        
//        NSLog(@"%@",self.navigationController);
//        self.folderView = [[FileNavigationViewController alloc] initWithFolder:[self.data objectAtIndex:indexPath.row] frame:self.view.frame];
//        
//        [self.navigationController pushViewController:self.folderView animated:YES];
//        
//    } else if ([[self.data objectAtIndex:indexPath.row] isKindOfClass:[File class]]) {
//        
//        [self.delegate fileSelected:[self.data objectAtIndex:indexPath.row]];
//    }
}

@end
