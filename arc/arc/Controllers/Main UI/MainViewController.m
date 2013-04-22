//
//  MainViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"

// Plugins
#import "SyntaxHighlightingPlugin.h"
#import "FontFamilyPlugin.h"
#import "FontSizePlugin.h"
#import "LineNumberPlugin.h"

@interface MainViewController ()
@property (nonatomic, strong) CodeViewController *codeViewController;
@property (nonatomic, strong) CodeViewController *secondCodeViewController;
@property (nonatomic, strong) UIView *leftBorder;
@property (nonatomic, strong) LeftViewController *leftViewController;
@property (nonatomic, strong) ApplicationState *appState;
@property NSArray *plugins;
- (void)fileSelected:(id<File>)file;
- (void)folderSelected:(id<Folder>)folder;
- (void)registerPlugins;
- (void)registerPlugin:(id<PluginDelegate>)plugin;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        _plugins = [NSArray arrayWithObjects:
                    [[FontFamilyPlugin alloc] init],
                    [[FontSizePlugin alloc] init],
                    [[LineNumberPlugin alloc] init],
                    [[SyntaxHighlightingPlugin alloc] init],
                    nil];
        _appState = [ApplicationState sharedApplicationState];        

        _leftViewController = [[LeftViewController alloc] init];
        _leftViewController.delegate = self;
        
        _codeViewController = [[CodeViewController alloc] init];
        _codeViewController.delegate = self;
    }
    return self;
}

- (void)registerPlugins
{
    for (id<PluginDelegate> plugin in _plugins) {
        [self registerPlugin:plugin];
    }
}

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // Register Plugin with Application State
    [_appState registerPlugin:plugin];
    
    // Register Plugin with SettingsViewControllerDelegate
    [_leftViewController registerPlugin:plugin];
    
    // Register Plugin with CodeViewController
    [_codeViewController registerPlugin:plugin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.masterView addSubview:_leftViewController.view];
    _leftViewController.view.frame = self.masterView.bounds;
    
    [self.detailView addSubview:_codeViewController.view];
    _codeViewController.view.frame = self.detailView.bounds;

    // Not sure if this is the best place for this.
    [self registerPlugins];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fileSelected:[_appState currentFileOpened]];
    [self folderSelected:[_appState currentFolderOpened]];
}

- (void)openIn:(id<File>)file
{
    [_leftViewController navigateTo:(id<Folder>)[file parent]];
    [self fileSelected:file];
}

- (void)dropboxAuthentication
{
    DBAccountManager *dbAccountManager = [DBAccountManager sharedManager];
    DBAccount *dbAccount = dbAccountManager.linkedAccount;
    if (!dbAccount) {
        [dbAccountManager addObserver:self block:^(DBAccount *dbAccount) {
            [_leftViewController forceFolderRefresh];
        }];
        // Link to the main view controller instance here.
        [dbAccountManager linkFromController:self];
    }
}

- (void)refreshCodeViewForSetting:(NSString *)setting
{
    [_codeViewController refreshForSetting:setting];
}

# pragma mark - Arc SplitView Controller Delegate

- (void)didResizeSubViewsBoundsChanged:(BOOL)boundsChanged
{
    [_codeViewController redrawCodeViewBoundsChanged:boundsChanged];
}

- (void)willShowMasterViewAnimated:(BOOL)animate
{
    if (_secondCodeViewController) {
        [_secondCodeViewController.view removeFromSuperview];
        _secondCodeViewController = nil;
    }
}

#pragma mark - MainViewControllerDelegate Methods

- (void)fileObjectSelected:(id<FileSystemObject>)fileSystemObject
{
    if ([[fileSystemObject class] conformsToProtocol:@protocol(Folder)]) {
        [self folderSelected:(id<Folder>)fileSystemObject];
    } else {
        [self fileSelected:(id<File>)fileSystemObject];
    }
}

- (void)secondFileObjectSelected:(id<FileSystemObject>)fileSystemObject
{
    if ([Utils isFileSupported:[fileSystemObject name]]) {
        [self hideMasterViewAnimated:YES];
        
        // add second code view
        _secondCodeViewController = [[CodeViewController alloc] init];
        for (id<PluginDelegate> plugin in _plugins) {
            [_secondCodeViewController registerPlugin:plugin];
        }
        _secondCodeViewController.delegate = self;
        [self.view addSubview:_secondCodeViewController.view];

        int width = floor(self.view.bounds.size.width/2);
        int height = _codeViewController.view.bounds.size.height;
        _codeViewController.view.frame = CGRectMake(0, 0,
                                                    width,
                                                    height);
        
        [_codeViewController redrawCodeViewBoundsChanged:YES];

        _secondCodeViewController.view.frame = CGRectMake(width, 0,
                                                          width,
                                                          height);
        [_secondCodeViewController showFile:(id<File>)fileSystemObject];
        [_secondCodeViewController redrawCodeViewBoundsChanged:YES];
        
        // add left border to second code view
        _leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, height)];
        _leftBorder.opaque = YES;
        _leftBorder.backgroundColor = _secondCodeViewController.foregroundColor;
        _leftBorder.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleRightMargin;
        [_secondCodeViewController.view addSubview:_leftBorder];

    } else {
        [Utils showUnsupportedFileDialog];
    }
}

- (void)layoutMultiView
{
    
}

- (id<FileSystemObject>)currentfile
{
    return [_appState currentFileOpened];
}

// Shows the file using the CodeViewController
- (void)fileSelected:(id<File>)file
{
    if ([Utils isFileSupported:[file name]]) {
        ApplicationState *appState = [ApplicationState sharedApplicationState];
        [appState setCurrentFileOpened:file];
        [_codeViewController showFile:file];
    } else {
        [Utils showUnsupportedFileDialog];
    }
}

// Updates Current Folder being Viewed
- (void)folderSelected:(id<Folder>)folder
{
    ApplicationState *appState = [ApplicationState sharedApplicationState];
    [appState setCurrentFolderOpened:folder];
    [_leftViewController navigateTo:folder];
}

@end
