//
//  SettingsViewController.m
//  arc
//
//  Created by Yong Michael on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, strong) NSMutableArray *settingOptions;
@property (nonatomic, strong) NSMutableArray *plugins;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ApplicationState *appState;
@end

@implementation SettingsViewController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _settingOptions = [NSMutableArray array];
        _plugins = [NSMutableArray array];
        _appState = [ApplicationState sharedApplicationState];
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
            
            // Section Setting Key
            [section setValue:setting
                       forKey:SECTION_SETTING_KEY];
            
            NSDictionary *properties = [plugin propertiesFor:setting];
            
            // Section Heading
            [section setValue:[properties objectForKey:PLUGIN_TITLE]
                       forKey:SECTION_HEADING];
            
            // Section Type
            [section setValue:[properties objectForKey:PLUGIN_TYPE]
                       forKey:SECTION_TYPE];
            
            // Set options depending on the type of the section.
            kSettingType type = [PluginUtilities settingTypeForNumber:[properties objectForKey:PLUGIN_TYPE]];
            switch (type) {
                case kMCQSettingType:
                    [section setValue:[properties objectForKey:PLUGIN_OPTIONS]
                               forKey:SECTION_OPTIONS];
                    break;
                case kRangeSettingType:
                    [section setValue:[properties objectForKey:PLUGIN_RANGE_MAX]
                               forKey:PLUGIN_RANGE_MAX];
                    [section setValue:[properties objectForKey:PLUGIN_RANGE_MIN]
                               forKey:PLUGIN_RANGE_MIN];
                    break;
                case kBoolSettingType:
                    break;
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
    
    kSettingType type = [PluginUtilities settingTypeForNumber:[sectionProperties objectForKey:SECTION_TYPE]];
    switch (type) {
        case kMCQSettingType:
            return [[sectionProperties objectForKey:SECTION_OPTIONS] count];
        default:
            // Other types have only one row.
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionProperties =
    (NSDictionary*)[_settingOptions objectAtIndex:section];
    
    kSettingType type = [PluginUtilities settingTypeForNumber:[sectionProperties objectForKey:SECTION_TYPE]];
    switch (type) {
        case kMCQSettingType:
            return [sectionProperties objectForKey:SECTION_HEADING];
        default:
            // Other types have no section heading.
            return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *sectionProperties =
    (NSDictionary*)[_settingOptions objectAtIndex:indexPath.section];
    
    kSettingType type = [PluginUtilities settingTypeForNumber:[sectionProperties objectForKey:SECTION_TYPE]];
    switch (type) {
        case kMCQSettingType:
            return [self mCQCellFromTableView:tableView
                               withProperties:sectionProperties
                        cellForRowAtIndexPath:indexPath];
        case kRangeSettingType:
            return [self rangeCellFromTableView:tableView
                                 withProperties:sectionProperties];
        case kBoolSettingType:
            // TODO.
        default:
            return nil;
    }
}

- (UITableViewCell*)mCQCellFromTableView:(UITableView *)tableView
                          withProperties:(NSDictionary*)properties
                   cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *option = [[properties
                             objectForKey:SECTION_OPTIONS]
                            objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"SettingsMCQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Plugin values need to be comparable somehow
    // easiest option is to make them all strings.
    NSString *value = [option objectForKey:PLUGIN_VALUE];
    NSString *settingKey = [properties objectForKey:SECTION_SETTING_KEY];
    
    BOOL isCurrentSettingThisRow = [[_appState settingForKey:settingKey] isEqualToString:value];
    if (isCurrentSettingThisRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [option objectForKey:PLUGIN_LABEL];
    return cell;
}

- (UITableViewCell*)rangeCellFromTableView:(UITableView *)tableView
                            withProperties:(NSDictionary*)properties
{
    static NSString *cellIdentifier = @"SettingsRangeCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }
    
    CGRect frame = CGRectMake(0.0, 0.0, 150.0, 10.0);
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self
               action:@selector(rangeSettingsChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    // Set slider appearance properties.
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = [[properties objectForKey:PLUGIN_RANGE_MIN] intValue];
    slider.maximumValue = [[properties objectForKey:PLUGIN_RANGE_MAX] intValue];
    slider.continuous = YES;
    
    // Set the slider's position.
    NSString *settingKey = [properties objectForKey:SECTION_SETTING_KEY];
    [slider setValue:[[_appState settingForKey:settingKey] intValue]
            animated:NO];
    
    // Setup the cell.
    cell.settingKey = settingKey;
    cell.accessoryView = slider;
    cell.textLabel.text = [properties objectForKey:SECTION_HEADING];
    return cell;
}

- (void)rangeSettingsChanged:(id)sender
{
    UISlider *slider = (UISlider *) sender;
    
    int value = lroundf(slider.value);
    [slider setValue:value animated:YES];
    
    SettingCell *cell = (SettingCell *) slider.superview;
    
    [self updateSetting:[NSNumber numberWithInt:value]
          forSettingKey:cell.settingKey
        reloadTableData:NO];
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
    cell.textLabel.text = [properties objectForKey:SECTION_HEADING];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    NSDictionary *sectionProperties =
    (NSDictionary*)[_settingOptions objectAtIndex:indexPath.section];
    
    int type = [[sectionProperties objectForKey:SECTION_TYPE] intValue];
    if (type == kMCQSettingType) {
        NSDictionary *option = [[sectionProperties
                                 objectForKey:SECTION_OPTIONS]
                                objectAtIndex:indexPath.row];
        
        NSString *value = [option objectForKey:PLUGIN_VALUE];
        NSString *settingKey = [sectionProperties objectForKey:SECTION_SETTING_KEY];
        
        // Unhighlight the row, and reload the table.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self updateSetting:value
              forSettingKey:settingKey
            reloadTableData:YES];
    }
    
}

- (void)updateSetting:(id<NSObject>)value
        forSettingKey:(NSString*)settingKey
      reloadTableData:(Boolean)reloadData
{
    // Update App State
    [_appState setSetting:value forKey:settingKey];
    
    // Refresh the code view.
    [self.delegate refreshCodeViewForSetting:settingKey];
    
    if (reloadData) {
        // Refresh tableView
        [_tableView reloadData];
    }
}

@end
