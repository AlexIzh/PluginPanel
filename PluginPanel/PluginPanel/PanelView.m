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
        
        _chooserView.allowsEmptySelection = NO;
        _chooserView.allowsMultipleSelection = NO;
        _chooserView.delegate = self;
        
        _chooserView.topBorderColor = [NSColor clearColor];
        _chooserView.bottomBorderColor = [NSColor darkGrayColor];
        _chooserView.leftBorderColor = [NSColor darkGrayColor];
        _chooserView.rightBorderColor = [NSColor clearColor];
        _chooserView.borderSides = -1;
        _chooserView.gradientStyle = 1;
        
//        _chooserView._buttonMatrix.backgroundColor = [NSColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
//        ((NSCell *)_chooserView._buttonMatrix.prototype).backgroundStyle = NSBackgroundStyleLight;
        [self addSubview:_chooserView];
    }
    return self;
}

- (void)chooserView:(DVTChooserView *)view userWillSelectChoices:(NSArray *)choices {
    DVTChoice *choice = [choices lastObject];
    self.contentView = [[choice representedObject] view];
}

- (void)chooserView:(DVTChooserView *)view userDidSelectChoices:(NSArray *)choices {
}

- (void)layout {
    [super layout];
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    [_chooserView setFrame:NSMakeRect(.0f, frameRect.size.height - 29.f, frameRect.size.width, 29.f)];
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
