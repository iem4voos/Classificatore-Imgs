//
//  AppDelegate.m
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12.
//  Copyright (c) 2012 mic. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate
@synthesize controller;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //NSLog(@"applicationDidFinishLaunching");
    [_window setCollectionBehavior:
     NSWindowCollectionBehaviorFullScreenPrimary];
    
    //[controller doSomething:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}



@end
