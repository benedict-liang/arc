//
//  SettingsViewController.m
//  arc
//
//  Created by Yong Michael on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property NSMutableArray *options;
@property NSMutableArray *plugins;
@property UITableView *tableView;
@end

@implementation SettingsViewController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _options = [NSMutableArray array];
        _plugins = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    self.title = @"Settings";
    
    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // Only register a plugin once.
    if ([_plugins indexOfObject:plugin] == NSNotFound) {
        [_plugins addObject:plugin];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_options count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_options objectAtIndex:section] objectForKey:@"keyValuePairs"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_options objectAtIndex:section] objectForKey:@"sectionName"];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *sectionProperties = [_options objectAtIndex:indexPath.section];
    
    // Types: Range, MCQ, Boolean
    if ([[sectionProperties valueForKey:@"type"] isEqualToString:@"mcq"]) {
        // Get the settings dictionary associated with this section.
        NSDictionary *options = [sectionProperties objectForKey:@"keyValuePairs"];
        NSArray *allKeys = [options allKeys];
        NSArray *allValues = [options objectsForKeys:allKeys notFoundMarker:@"None"];
        
        // TODO: handle case where there are many options (e.g. >5)
        // Get the key-value pair to associate with this row.
        NSString *key = [allKeys objectAtIndex:indexPath.row];
        NSString *value = [allValues objectAtIndex:indexPath.row];
        
        // Set the row properties.
        NSString *currentSetting = [[ApplicationState sharedApplicationState] settingForKey:[sectionProperties valueForKey:@"settingsKey"]];
        if ([value isEqualToString:currentSetting]) {
            // Put a checkmark on the row if it's the one for the currently applied setting.
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        cell.textLabel.text = key;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Get the properties associated with this section.
    NSDictionary *sectionProperties = [_options objectAtIndex:indexPath.section];
    NSDictionary *options = [sectionProperties objectForKey:@"keyValuePairs"];
    NSArray *allKeys = [options allKeys];
    NSArray *allValues = [options objectsForKeys:allKeys notFoundMarker:@"None"];
    
    // Get the value associated with the row.
    NSString *value = [allValues objectAtIndex:indexPath.row];
    
    ApplicationState *state = [ApplicationState sharedApplicationState];
    
    // Update the appropriate setting using the key associated with this section.
    NSString *currentKey = [sectionProperties valueForKey:@"settingsKey"];
    [state setSetting:value forKey:currentKey];
    
    // Add a checkmark to the row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

    // Refresh the code view.
    [self.delegate refreshCodeViewForSetting:currentKey];

    // Unhighlight the row, and reload the table.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

@end
