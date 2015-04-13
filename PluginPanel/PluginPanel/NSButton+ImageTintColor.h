//
//  NSButton+ImageTintColor.h
//
//  Created by Karim Nassar on 5/1/14.
//  Copyright (c) 2014 Hungry Melon Studio, LLC. All rights reserved.
//
//  This source code is distributed As-Is with no warranties.
//  You may use this source however you like in any application, as long as you retain this header.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (ImageTintColor)

- (void)setTintColor:(NSColor *)color;
- (void)setTintColor:(NSColor *)color forState:(NSCellStateValue)state;
- (NSColor *)tintColor;
- (NSColor *)tintColorForState:(NSCellStateValue)state;

@end
