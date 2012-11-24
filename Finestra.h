//
//  Finestra.h
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12.
//  Copyright (c) 2012 mic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IlControllerViewController.h"

@interface Finestra : NSWindow

@property (unsafe_unretained) IBOutlet IlControllerViewController *ilControllerLui;


- (BOOL)acceptsFirstResponder;
- (void)keyDown:(NSEvent *)event;
 
@end
