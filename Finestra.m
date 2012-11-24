//
//  Finestra.m
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12.
//  Copyright (c) 2012 mic. All rights reserved.
//

#import "Finestra.h"

@implementation Finestra

@synthesize ilControllerLui;

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)event {
    [ilControllerLui keyDown:event];
}

//  MDItemSetAttribute


@end
