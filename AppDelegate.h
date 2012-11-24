//
//  AppDelegate.h
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12
//  Copyright (c) 2012 mic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IlControllerViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (unsafe_unretained) IBOutlet IlControllerViewController *controller;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;

@end
