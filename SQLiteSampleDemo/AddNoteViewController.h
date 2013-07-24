//
//  AddNoteViewController.h
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNoteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textFieldForName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForNote;

- (IBAction)fnForNavigationAddButtonPressed:(id)sender;
- (IBAction)fnForNavigationCancelButtonPressed:(id)sender;

@end
