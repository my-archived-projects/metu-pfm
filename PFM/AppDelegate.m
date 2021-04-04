//
//  AppDelegate.m
//  PFM
//
//  Created by Metehan Karabiber on 2/27/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AccountUtils.h"
#import "Account.h"
#import "Utils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSArray *capitals = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupCapital)]];
	
	NSManagedObjectContext *ctx = [Utils getContext];

    if (!capitals || capitals.count == 0) {
        Account *capital = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                         inManagedObjectContext:ctx];
        capital.name = startingcapital;
        capital.balance = @(0);
        capital.isActive = @(YES);
		capital.type = @(-1);
		capital.subtype = @(-1);
        capital.group = @(AccountGroupCapital);
		capital.invrelAccount = [NSSet set];

        Account *pastYear = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                          inManagedObjectContext:ctx];
        pastYear.name = pastYears;
        pastYear.balance = @(0);
        pastYear.isActive = @(YES);
		pastYear.type = @(-1);
		pastYear.subtype = @(-1);
        pastYear.group = @(AccountGroupCapital);
		pastYear.invrelAccount = [NSSet set];

        Account *curYear = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                             inManagedObjectContext:ctx];
        curYear.name = currentYear;
        curYear.balance = @(0);
        curYear.isActive = @(YES);
		curYear.type = @(-1);
		curYear.subtype = @(-1);
        curYear.group = @(AccountGroupCapital);
		curYear.invrelAccount = [NSSet set];

        [ctx save:NULL];
    }
    
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
	
	self.window.rootViewController = viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	NSManagedObjectContext *managedObjectContext = [Utils getContext];
	if (managedObjectContext != nil) {
		NSError *error = nil;
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}

}

@end
