//
//  HomeViewController.h
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrayForNotesData;
@property (strong, nonatomic) IBOutlet UITableView *tableViewForNotesDisplay;

- (IBAction)fnForNavigationBackButtonPressed:(id)sender;
- (IBAction)fnForNavigationAddButtonPressed:(id)sender;

@end
