//
//  PanelView.m
//  show
//
//  Created by Александр Северьянов on 07.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "PanelView.h"

@implementation PanelView

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _chooserView = [[NSClassFromString(@"DVTChooserView") alloc] initWithFrame:NSZeroRect];
        _chooserView.delegate = self;
        
        _chooserView.topBorderColor = [NSColor clearColor];
        _chooserView.bottomBorderColor = [NSColor darkGrayColor];
        _chooserView.leftBorderColor = [NSColor darkGrayColor];
        _chooserView.rightBorderColor = [NSColor clearColor];
//        _chooserView.shadowColor = [NSColor blackColor];
//        _chooserView.shadowSides = 1;
        _chooserView.borderSides = -1;
        [self addSubview:_chooserView];
//        NSImage *img =[[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"com.moqod.show"] pathForImageResource:@"bookmark_icon1.png"]] autorelease];
//        for (int i = 0; i < 20; i++) {
//            DVTChoice *choise = [[NSClassFromString(@"DVTChoice") alloc] initWithTitle:@"ex" toolTip:@"example" image:img representedObject:nil];
//            [_chooserView.mutableChoices addObject:choise];
//            DVTChoice *choise2 = [[NSClassFromString(@"DVTChoice") alloc] initWithTitle:@"ex" toolTip:@"example" image:img representedObject:nil];
//            [_chooserView.mutableChoices addObject:choise2];
//        }
    }
    return self;
}

- (void)chooserView:(DVTChooserView *)view userWillSelectChoices:(NSArray *)choices {
    DVTChoice *choice = [choices lastObject];
    self.contentView = [[choice representedObject] view];
//    PluginLog(@"%s, object class = %@", __PRETTY_FUNCTION__, NSStringFromClass([object class]));
}

- (void)chooserView:(DVTChooserView *)view userDidSelectChoices:(NSArray *)choices {
//    PluginLog(@"%s, object class = %@", __PRETTY_FUNCTION__, NSStringFromClass([object class]));
}

- (void)layout {
    [super layout];
//    PluginLog(@"%s", __PRETTY_FUNCTION__);
//    _chooserView.frame =;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    [_chooserView setFrame:NSMakeRect(.0f, frameRect.size.height - 22.f, frameRect.size.width, 22.f)];
    [_contentView setFrame:NSMakeRect(.0f, .0f, frameRect.size.width, _chooserView.frame.origin.y)];
}

- (void)setContentView:(NSView *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:_contentView];
        [_contentView setFrame:NSMakeRect(.0f, .0f, self.bounds.size.width, _chooserView.frame.origin.y)];
    }
}

@end
