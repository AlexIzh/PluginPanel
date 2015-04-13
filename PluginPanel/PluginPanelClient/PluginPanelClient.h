//
//  PluginPanelClient.h
//  PluginPanel
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

extern NSString *const PluginPanelAddPluginNotification;
extern NSString *const PluginPanelRemovePluginNotification;
extern NSString *const PluginPanelDidLoadedWindowNotification;
extern NSString *const PluginPanelWindowNotificationKey;
@class DVTChoice;

FOUNDATION_EXPORT void PluginPanelAddPlugin(DVTChoice * choise, NSWindow *window);
FOUNDATION_EXPORT void PluginPanelRemovePlugin(DVTChoice * choise);

//@interface DVTChoice : NSObject //uncomment it if you don't use DVTKit.h file
//- (id)initWithTitle:(id)arg1 toolTip:(id)arg2 image:(id)arg3 representedObject:(id)arg4;
//@end