//
//  AppDelegate.m
//  iOS-Sample
//
//  Created by negwiki on 16/1/24.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import "NONAppDelegate.h"

@interface NONAppDelegate ()

@end

@implementation NONAppDelegate

#pragma mark application lifecycle method
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillResignActive:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
