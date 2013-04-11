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
        self.title = @"Settings";
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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    
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
            
            // Reference to the plugin.
            [section setValue:plugin
                       forKey:SECTION_PLUGIN_OBJECT];
            
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
            kSettingType type =
                [PluginUtilities settingTypeForNumber:[properties objectForKey:PLUGIN_TYPE]];
            
            switch (type) {
                case kMCQSettingType:
                    [section setValue:[properties objectForKey:PLUGIN_OPTIONS]
                               forKey:SECTION_OPTIONS];
                    break;
                    
                case kRangeSettingType:
                    [section setValue:[properties objectForKey:PLUGIN_OPTION_RANGE_MAX]
                               forKey:PLUGIN_OPTION_RANGE_MAX];
                    [section setValue:[properties objectForKey:PLUGIN_OPTION_RANGE_MIN]
                               forKey:PLUGIN_OPTION_RANGE_MIN];
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionProperties =
        (NSDictionary*)[_settingOptions objectAtIndex:section];
    
    kSettingType type =
        [PluginUtilities settingTypeForNumber:
            [sectionProperties objectForKey:SECTION_TYPE]];

    int rowNumber;
    switch (type) {
        case kMCQSettingType:
            rowNumber = [[sectionProperties objectForKey:SECTION_OPTIONS] count];
            if (rowNumber > 5) {
                return 1; // We want to use a picker view for long sections.
            }
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
    
    kSettingType type =
        [PluginUtilities settingTypeForNumber:[sectionProperties objectForKey:SECTION_TYPE]];

    switch (type) {
        case kMCQSettingType:
            return [sectionProperties objectForKey:SECTION_HEADING];
        default:
            // Other types have no section heading.
            return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *sectionProperties =
        (NSDictionary*)[_settingOptions objectAtIndex:indexPath.section];
    
    kSettingType type =
        [PluginUtilities settingTypeForNumber:[sectionProperties objectForKey:SECTION_TYPE]];

    switch (type) {
        case kMCQSettingType:
            return [self mCQCellFromTableView:tableView
                               withProperties:sectionProperties
                        cellForRowAtIndexPath:indexPath];

        case kRangeSettingType:
            return [self rangeCellFromTableView:tableView
                                 withProperties:sectionProperties];

        case kBoolSettingType:
            return [self boolCellFromTableView:tableView
                                withProperties:sectionProperties];

        default:
            return nil;
    }
}

- (UITableViewCell*)mCQCellFromTableView:(UITableView *)tableView
                          withProperties:(NSDictionary*)properties
                   cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Init the cell.
    NSString *cellIdentifier = [properties objectForKey:SECTION_HEADING];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if ([[properties objectForKey:SECTION_OPTIONS] count] < 5) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:cellIdentifier];
        }
    }
    
    NSString *settingKey = [properties objectForKey:SECTION_SETTING_KEY];
    if ([[properties objectForKey:SECTION_OPTIONS] count] > 5) {
        // This is a long list. Use a single cell with a link to a view
        // with the rest of the items.
        NSString *currentSettingKey = [_appState settingForKey:settingKey];
        NSString *currentSetting;
        for (NSDictionary *currentOption in [properties objectForKey:SECTION_OPTIONS]) {
            if ([[currentOption objectForKey:PLUGIN_OPTION_VALUE] isEqualToString:currentSettingKey]) {
                currentSetting = [currentOption objectForKey:PLUGIN_OPTION_LABEL];
                break;
            }
        }
        cell.textLabel.text = @"Current Setting";
        cell.detailTextLabel.text = currentSetting;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        // Individual option corresponding to the row within this section.
        NSDictionary *option = [[properties
                                 objectForKey:SECTION_OPTIONS]
                                objectAtIndex:indexPath.row];
        
        
        // Plugin values need to be comparable somehow
        // easiest option is to make them all strings.
        NSString *value = [option objectForKey:PLUGIN_OPTION_VALUE];
        
        BOOL isCurrentSettingThisRow = [[_appState settingForKey:settingKey] isEqualToString:value];
        if (isCurrentSettingThisRow) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = [option objectForKey:PLUGIN_OPTION_LABEL];
        
        // Allow the plugin to customise this cell, if applicable.
        id<PluginDelegate> plugin = [properties objectForKey:SECTION_PLUGIN_OBJECT];
        if ([plugin respondsToSelector:@selector(customiseTableViewCell:options:)]) {
            [plugin customiseTableViewCell:&cell options:option];
        }
    }
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
    slider.minimumValue = [[properties objectForKey:PLUGIN_OPTION_RANGE_MIN] intValue];
    slider.maximumValue = [[properties objectForKey:PLUGIN_OPTION_RANGE_MAX] intValue];
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

// Called when a slider's value has been changed.
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

// Initialises a cell with a switch, used to handle
// boolean settings.
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
    if (type == kMCQSettingType && [[sectionProperties objectForKey:SECTION_OPTIONS] count] < 5) {
        NSDictionary *option = [[sectionProperties
                                 objectForKey:SECTION_OPTIONS]
                                objectAtIndex:indexPath.row];
        
        NSString *value = [option objectForKey:PLUGIN_OPTION_VALUE];
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
