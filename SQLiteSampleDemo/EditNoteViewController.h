//
//  EditNoteViewController.h
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNoteViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dictionaryForNote;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForNote;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonForEditNote;

- (IBAction)fnForNavigationEditButtonPressed:(id)sender;
- (IBAction)fnForNavigationCancelButtonPressed:(id)sender;
@end
