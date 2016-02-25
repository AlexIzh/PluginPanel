//
//  PluginPanel.h
//  PluginPanel
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface PluginPanel : NSObject {
    NSMutableSet        *_windowsSet;
    NSMutableSet        *_viewsArray;
}
@end