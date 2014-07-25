//
//  KTAppDelegate.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTAppDelegate.h"
#import "KTPostStore.h"

@implementation KTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // hit dataloader with appropriate method
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[KTPostStore sharedStore]saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // call refresh
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
