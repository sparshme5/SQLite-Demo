//
//  AppDelegate.h
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

- (void)createEditableCopyOfDatabaseIfNeeded;
+(sqlite3 *)getNewDBConnection;

@end
