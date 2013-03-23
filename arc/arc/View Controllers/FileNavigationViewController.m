//
//  UIFileNavigationController.m
//  arc
//
//  Created by omer iqbal on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileNavigationViewController.h"

@interface FileNavigationViewController ()

@end

@implementation FileNavigationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setupTable {
    UITableView* table = [[UITableView alloc] initWithFrame:[self defaultFrame] style:UITableViewStylePlain];
    [table setDataSource:self];
    [table setDelegate:self];
    [table reloadData];
    [self setView:table];
    
}
- (id)initWithFiles:(NSArray *)files {
    self = [super init];
    if (self) {
        _data = files;
        [self setupTable];
    }
    return self;
}
- (id)initWithFolder:(Folder *)folder {
    self = [super init];
    if (self) {
        _data = [folder getContents];
        [self setupTable];
    }
    return self;
}
    //TODO temporary. Should be managed by MainViewController as it depends on orientation
- (CGRect)defaultFrame {
    return CGRectMake(0, 0, 200, 600);
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if ([[self.data objectAtIndex:indexPath.row] isKindOfClass:[FileObject class]]) {
        
        cell.textLabel.text = [(FileObject*)[self.data objectAtIndex:indexPath.row] name];
        
    } else if([[self.data objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    }
    
    return cell;
}
#pragma mark - Table view delegate

//TODO implement protocol to send selected result back to MainView VC

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
