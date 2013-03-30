//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileNavigationViewController.h"
#import "RootFolder.h"
@interface FileNavigationViewController ()
@property Folder *currentFolder;
@property NSArray *filesAndFolders;
@end

@implementation FileNavigationViewController
@synthesize delegate;
@synthesize currentFolder = _currentFolder;
@synthesize filesAndFolders = _filesAndFolders;

- (id)init
{
    self = [super init];
    if (self) {
        // tmp.
        _currentFolder = [RootFolder sharedRootFolder];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tmp.
    _filesAndFolders = [NSArray arrayWithObjects:@"asdf", @"qwer", @"zxcv", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                             style:UITableViewStylePlain];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
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

//    // Configure the cell...
//    if ([[self.data objectAtIndex:indexPath.row] isKindOfClass:[FileObject class]]) {
//        
//        cell.textLabel.text = [(FileObject*)[self.data objectAtIndex:indexPath.row] name];
//        
//    } else if([[self.data objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
//        cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
//    }
    
    cell.textLabel.text = [_filesAndFolders objectAtIndex:indexPath.row];
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
