//
//  AppDelegate.m
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createEditableCopyOfDatabaseIfNeeded];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SQLite Manager Methods
- (void)createEditableCopyOfDatabaseIfNeeded
{
	NSLog(@"Creating editable copy of database :?");
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"notesdb.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success)
    {        
        NSLog(@"DB File already present in the documents :)");
        return;
    }
	//The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"notesdb.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
    {
		NSLog(@"Failed to create writable database file :(");
	}
    else
    {
        NSLog(@"DB File copied to documents Successfully :)");
    }
}

+(sqlite3 *) getNewDBConnection
{
	sqlite3 *newDBconnection;	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"notesdb.sqlite"];
	
	//Open the database. The database was prepared outside the application.
	if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK)
    {
		NSLog(@"Database Successfully Opened :)");
	}
    else
    {
		NSLog(@"Error in opening database :(");
	}
	return newDBconnection;
}

@end
