//
//  LongSettingListViewController.m
//  arc
//
//  Created by Jerome Cheng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LongSettingListViewController.h"

@interface LongSettingListViewController ()

@property NSArray *options;

@end

@implementation LongSettingListViewController

- (id)initWithProperties:(NSDictionary *)properties delegate:(id)delegate
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _properties = properties;
        _delegate = delegate;
        self.title = [_properties valueForKey:SECTION_HEADING];
        _options = [_properties valueForKey:SECTION_OPTIONS];
    }
    return self;
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
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *currentOption = [_options objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentOption valueForKey:PLUGIN_OPTION_LABEL];
    
    // Check if the option is currently selected.
    NSString *currentSettingValue = [[ApplicationState sharedApplicationState] settingForKey:[_properties valueForKey:SECTION_SETTING_KEY]];
    NSString *currentOptionValue = [currentOption valueForKey:PLUGIN_OPTION_VALUE];
    if ([currentOptionValue isEqualToString:currentSettingValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentOption = [_options objectAtIndex:indexPath.row];

    [_delegate updateSetting:[currentOption valueForKey:PLUGIN_OPTION_VALUE]
              forSettingKey:[_properties valueForKey:SECTION_SETTING_KEY]
            reloadTableData:YES];
    
    // Reload the table.
    [tableView reloadData];
}


@end
