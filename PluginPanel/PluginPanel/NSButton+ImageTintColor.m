//
//  NSButton+ImageTintColor.m
//
//  Created by Karim Nassar on 5/1/14.
//  Copyright (c) 2014 Hungry Melon Studio, LLC. All rights reserved.
//
//  This source code is distributed As-Is with no warranties.
//  You may use this source however you like in any application, as long as you retain this header.
//

#import "NSButton+ImageTintColor.h"
#import <objc/objc-runtime.h>
#import <QuartzCore/QuartzCore.h>


#define kTintColorPropertyKeyOn    @"com.hungrymelon-tintColorPropertyState-ON"
#define kTintColorPropertyKeyOff   @"com.hungrymelon-tintColorPropertyState-OFF"
#define kTintColorPropertyKeyMixed @"com.hungrymelon-tintColorPropertyState-MIXED"

@implementation NSButton (ImageTintColor)

- (void)setTintColor:(NSColor *)color
{
    return [self setTintColor:color forState:NSOffState];
}

- (void)setTintColor:(NSColor *)color forState:(NSCellStateValue)state
{
    switch (state) {
        case NSOffState:
            objc_setAssociatedObject(self, kTintColorPropertyKeyOff, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        case NSOnState:
            objc_setAssociatedObject(self, kTintColorPropertyKeyOn, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        case NSMixedState:
            objc_setAssociatedObject(self, kTintColorPropertyKeyMixed, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
            
        default:
            break;
    }
    if (self.state == state) {
        [self updateLayerForTintColor:color];
    }
}

- (NSColor *)tintColor
{
    return [self tintColorForState:NSOffState];
}

- (NSColor *)tintColorForState:(NSCellStateValue)state
{
    switch (state) {
        case NSOffState:
            return objc_getAssociatedObject(self, kTintColorPropertyKeyOff);

        case NSOnState:
            return objc_getAssociatedObject(self, kTintColorPropertyKeyOn);

        case NSMixedState:
            return objc_getAssociatedObject(self, kTintColorPropertyKeyMixed);

        default:
            return nil;
    }
}

- (void)updateLayerForTintColor:(NSColor *)tintColor
{
    [self.layer setBackgroundColor:[NSColor clearColor].CGColor];
    if (tintColor) {
        if (!self.layer) {
            [self setWantsLayer:YES];
        }
        if (!self.layer.mask) {
            NSImage *template = [self.image copy];
            [template setTemplate:YES];
            [self setImage:nil];
            CALayer *maskLayer = [CALayer layer];
            [maskLayer setContents:template];
            [maskLayer setFrame:self.bounds];
            [self.layer setMask:maskLayer];
        }
        [self.layer setBackgroundColor:tintColor.CGColor];
    }
    [self setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

//- (void)setState:(NSCellStateValue)state
//{
//    [(NSButtonCell *)self.cell setState:(NSInteger)state];
//    [self updateLayerForTintColor:[self tintColorForState:(NSCellStateValue)self.state]];
//}
//
//- (NSCellStateValue)buttonState
//{
//    return (NSCellStateValue)self.state;
//}

@end
