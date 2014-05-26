//
//  PanelView.h
//  show
//
//  Created by Александр Северьянов on 07.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DVTKit.h"

@interface PanelView : NSView
@property (nonatomic, readonly) DVTChooserView *chooserView;
@property (nonatomic, retain) NSView               *contentView;
@property (nonatomic, assign) NSWindow          *mainWindow;
@end
