//
//  SettingsViewController.m
//  arc
//
//  Created by Yong Michael on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property NSMutableArray *settingOptions;
@property NSMutableArray *plugins;
@property UITableView *tableView;
@end

@implementation SettingsViewController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _settingOptions = [NSMutableArray array];
        _plugins = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    self.title = @"Settings";
    
    [self generateSections];
    
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

- (void)generateSections
{
    _settingOptions = [NSMutableArray array];
    for (id<PluginDelegate> plugin in _plugins) {
        for (NSString *setting in [plugin settingKeys]) {
            NSMutableDictionary *section = [NSMutableDictionary dictionary];
            
            NSDictionary *properties = [plugin propertiesFor:setting];
            
            // Section Heading
            [section setValue:[properties objectForKey:PLUGIN_TITLE]
                       forKey:@"sectionHeading"];

            // TODO.
            // add utils method to make "casting"/comparing enums easier
            int type = [[properties objectForKey:PLUGIN_TYPE] intValue];
            [section setValue:[properties objectForKey:PLUGIN_TYPE]
                       forKey:@"sectionType"];

            if (type == kMCQSettingType) {
                [section setValue:[properties objectForKey:PLUGIN_OPTIONS]
                           forKey:@"sectionOptions"];
            }

            [_settingOptions addObject:section];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_settingOptions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionProperties = (NSDictionary*)[_settingOptions objectAtIndex:section];
    int type = [[sectionProperties objectForKey:@"sectionType"] intValue];
    
    if (type == kMCQSettingType) {
        return [[sectionProperties objectForKey:@"sectionOptions"] count];
    } else {
        // Bool and range types have only one row.
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionProperties =
        (NSDictionary*)[_settingOptions objectAtIndex:section];
    
    int type = [[sectionProperties objectForKey:@"sectionType"] intValue];
    if (type == kMCQSettingType) {
        return [sectionProperties objectForKey:@"sectionHeading"];
    }

    // Other types of settings are single row items.
    // no section heading required.
    return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *sectionProperties =
        (NSDictionary*)[_settingOptions objectAtIndex:indexPath.section];

    int type = [[sectionProperties objectForKey:@"sectionType"] intValue];
    if (type == kMCQSettingType) {
        NSDictionary *option = [[sectionProperties
                                 objectForKey:@"sectionOptions"]
                                    objectAtIndex:indexPath.row];
        return [self mCQCellFromTableView:tableView
                           withProperties:option];
    } else if (type == kRangeSettingType) {
        return [self rangeCellFromTableView:tableView
                             withProperties:sectionProperties];
    } else if (type == kBoolSettingType) {
        // TODO.
        return nil;
    }
    
    return nil;
}

- (UITableViewCell*)mCQCellFromTableView:(UITableView *)tableView
                          withProperties:(NSDictionary*)properties
{
    static NSString *cellIdentifier = @"SettingsMCQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [properties objectForKey:PLUGIN_LABEL];
    return cell;
}

- (UITableViewCell*)rangeCellFromTableView:(UITableView *)tableView
                            withProperties:(NSDictionary*)properties
{
    static NSString *cellIdentifier = @"SetingsRangeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // TODO.

    cell.textLabel.text = [properties objectForKey:@"sectionHeading"];
    return cell;
}

- (UITableViewCell*)boolCellFromTableView:(UITableView *)tableView
                           withProperties:(NSDictionary*)properties
{
    static NSString *cellIdentifier = @"SettingsBoolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchview;
    cell.textLabel.text = [properties objectForKey:@"sectionHeading"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Get the properties associated with this section.
    NSDictionary *sectionProperties = [_settingOptions objectAtIndex:indexPath.section];
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
