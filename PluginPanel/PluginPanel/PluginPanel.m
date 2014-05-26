//
//  show.m
//  show
//
//  Created by Александр Северьянов on 19.05.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "PluginPanel.h"
#import "DVTKit.h"
#import "IDEKit.h"
#import <objc/runtime.h>
#import "PanelView.h"
#import "PluginPanelClient.h"

NSString *const PluginButtonIdentifier = @"PluginButtonIdentifier";

@class PluginButtonProvider;
@class PluginPanel;

@interface PluginButtonProvider : NSObject <IDEToolbarItemProvider>
+ (id)itemForItemIdentifier:(id)arg1 forToolbarInWindow:(id)arg2;
+ (DVTSplitView *)splitViewForWindow:(NSWindow *)window;
@end

@interface PluginPanel ()
- (void)shouldResizePanelView:(NSNotification *)note;
- (PanelView *)myViewForWindow:(NSWindow *)window;
@end

@implementation PluginPanel
+ (void)pluginDidLoad:(NSBundle *)plugin {
    [self sharedPlugin];
}
+ (id)sharedPlugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
    return sharedPlugin;
}

- (id)init {
    if (self = [super init]) {
        _windowsSet = [NSMutableSet new];
        _viewsArray = [NSMutableSet new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeNotification:) name:NSWindowDidUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindowNotification:) name:NSWindowWillCloseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldAddPlugin:) name:PluginPanelAddPluginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRemovePlugin:) name:PluginPanelRemovePluginNotification object:nil];
    }
    return self;
}

- (void)closeWindowNotification:(NSNotification *)note {
    NSWindow *window = note.object;
    if (window) {
        PanelView *view = nil;
        for (PanelView *v in _viewsArray) {
            if (v.mainWindow == window) {
                view = v;
                break;
            }
        }
        if (view) {
            [_viewsArray removeObject:view];
        }
        [_windowsSet removeObject:window];
    }
}

- (void)activeNotification:(NSNotification *)notif {
    for (NSWindow *window in [NSApp windows]) {
        if ([_windowsSet containsObject:window]) continue;
        [_windowsSet addObject:window];
        IDEToolbarDelegate *delegate = (IDEToolbarDelegate *)window.toolbar.delegate;
        if ([delegate isKindOfClass:NSClassFromString(@"IDEToolbarDelegate")]) {
            IDEToolbarItemProxy * proxy = [[NSClassFromString(@"IDEToolbarItemProxy") alloc] initWithItemIdentifier:PluginButtonIdentifier];
            proxy.providerClass = [PluginButtonProvider class];
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:delegate.toolbarItemProviders];
            [d setObject:proxy forKey:proxy.toolbarItemIdentifier];
            delegate.toolbarItemProviders = d;
            NSMutableArray *ar = [NSMutableArray arrayWithArray:delegate.allowedItemIdentifiers];
            [ar addObject:proxy.toolbarItemIdentifier];
            delegate.allowedItemIdentifiers = ar;
            [window.toolbar insertItemWithItemIdentifier:PluginButtonIdentifier atIndex:6];
            [[NSNotificationCenter defaultCenter] postNotificationName:PluginPanelDidLoadedWindowNotification object:nil userInfo:[NSDictionary dictionaryWithObject:window forKey:PluginPanelWindowNotificationKey]];
        }
    }
}

- (void)shouldAddPlugin:(NSNotification *)note {
    DVTChoice *plugin = note.object;
    if (plugin) {
        NSWindow *window = [[note userInfo] objectForKey:PluginPanelWindowNotificationKey];
        PanelView *panel = [self myViewForWindow:window];
        [panel.chooserView.mutableChoices addObject:plugin];
        panel.contentView = [[[[panel.chooserView mutableChoices] lastObject] representedObject] view];
        [panel setFrame:panel.frame];
    }
}

- (void)shouldRemovePlugin:(NSNotification *)note {
    DVTChoice *plugin = note.object;
    if (plugin) {
        for (NSWindow *window in _windowsSet) {
            PanelView *panel = [self myViewForWindow:window];
            [panel.chooserView.mutableChoices removeObject:plugin];
            panel.contentView = [[[[panel.chooserView mutableChoices] lastObject] representedObject] view];
            [panel setFrame:panel.frame];
        }
    }
}

- (void)shouldResizePanelView:(NSNotification *)note {
    NSSplitView *view = note.object;
    if (view == [PluginButtonProvider splitViewForWindow:[NSApp mainWindow]]) {
        PanelView *v = nil;
        DVTSplitView *split = [PluginButtonProvider splitViewForWindow:[NSApp mainWindow]];
        for (NSView *sub in split.subviews) {
            if ([sub isKindOfClass:[PanelView class]]) {
                v = (PanelView*)sub;
                break;
            }
        }
        [v setFrame:[view bounds]];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PanelView *)myViewForWindow:(NSWindow *)window {
    PanelView *v = nil;
    DVTSplitView *split = [PluginButtonProvider splitViewForWindow:window];
    for (NSView *sub in split.subviews) {
        if ([sub isKindOfClass:[PanelView class]]) {
            v = (PanelView*)sub;
            break;
        }
    }
    if (!v) {
        for (PanelView *view in _viewsArray) {
            if (view.mainWindow == window) {
                v = view;
                break;
            }
        }
        if (!v) {
            v = [[PanelView alloc] initWithFrame:NSZeroRect];
            v.mainWindow = window;
            [_viewsArray addObject:v];
        }
    }
    return v;
}

- (void)actionButton:(NSButton*)sender {

}

@end

@implementation PluginButtonProvider

+ (DVTSplitView *)splitViewForWindow:(NSWindow *)window {
    DVTSplitView *slpitView = nil;
//    if (slpitView) return slpitView;
    for (NSView *sub in [window.contentView subviews]) {
        if ([sub isMemberOfClass:NSClassFromString(@"DVTTabSwitcher")]) {
            for (NSView *sub1 in [sub subviews]) {
                if ([sub1 isMemberOfClass:[NSTabView class]]) {
                    for (NSView *s in [[[(NSTabView *)sub1 selectedTabViewItem] view] subviews]) {
                        for (NSView *s1 in s.subviews) {
                            if ([s1 isMemberOfClass:NSClassFromString(@"DVTSplitView")]) {
                                slpitView = (DVTSplitView *)s1;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    return slpitView;
}

+ (id)itemForItemIdentifier:(id)arg1 forToolbarInWindow:(id)arg2 {
    if ([arg1 isEqualToString:PluginButtonIdentifier]) {
        NSImage *img =[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"com.moqod.PluginPanel"] pathForImageResource:@"plugin_icon"]];
        NSButton * button = [[NSButton alloc] initWithFrame:NSMakeRect(.0f, .0f, 50.f, 30.f)];
        [button setButtonType:NSOnOffButton];
        [button setBezelStyle:NSRecessedBezelStyle];
        [button setBordered:NO];
        [button setImage:img];
        DVTGenericButtonViewController *bvc = [(DVTGenericButtonViewController*)[NSClassFromString(@"DVTGenericButtonViewController") alloc] initWithButton:button actionBlock:^(NSButton *sender){
            NSWindow *window = arg2;
            NSToolbarItem *item = nil;
            for (NSToolbarItem *it in [[window toolbar] items]) {
                if ([it.target isMemberOfClass:NSClassFromString(@"_IDEWorkspacePartsVisibilityToolbarViewController")]) {
                    item = it;
                    break;
                }
            }
            NSSegmentedControl *control = (NSSegmentedControl *)item.view;
            if ([sender state] == NSOnState) {
                
                if (![control isSelectedForSegment:2]) {
                    [control setSelected:YES forSegment:2];
                    [item.target performSelector:item.action withObject:control];
                }
                DVTSplitView *splitView = [PluginButtonProvider splitViewForWindow:window];
                PanelView *myView = [[PluginPanel sharedPlugin] myViewForWindow:window];
                myView.frame = splitView.bounds;
                [myView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
                for (NSView *sub in splitView.subviews) {
                    [sub setHidden:YES];
                }
                [splitView addSubview:myView];
                [[NSNotificationCenter defaultCenter] addObserver:[PluginPanel sharedPlugin] selector:@selector(shouldResizePanelView:) name:NSSplitViewDidResizeSubviewsNotification object:nil];
            } else {
                //                if ([control isSelectedForSegment:2]) {
                //                    [control setSelected:NO forSegment:2];
                //                    [item.target performSelector:item.action withObject:control];
                //                }
                DVTSplitView *splitView = [PluginButtonProvider splitViewForWindow:window];
                PanelView *myView = [[PluginPanel sharedPlugin] myViewForWindow:window];
                [myView removeFromSuperview];
                for (NSView *sub in splitView.subviews) {
                    [sub setHidden:NO];
                }
                [[NSNotificationCenter defaultCenter] removeObserver:[PluginPanel sharedPlugin] name:NSSplitViewDidResizeSubviewsNotification object:nil];
            }
        } itemIdentifier:PluginButtonIdentifier window:arg2];
        bvc.label = @"plugins";
        DVTViewControllerToolbarItem *c = [ NSClassFromString(@"DVTViewControllerToolbarItem") toolbarItemWithViewController:bvc];
        c.label = @"plugins";
        c.toolTip = @"hide or show the plugin panel";
        return c;
    }
    return nil;
}
@end