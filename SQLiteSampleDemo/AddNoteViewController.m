//
//  AddNoteViewController.m
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import "AddNoteViewController.h"
#import "AppDelegate.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)fnForNavigationAddButtonPressed:(id)sender
{
    [self.textFieldForName resignFirstResponder];
    [self.textFieldForNote resignFirstResponder];
    
    if([self.textFieldForName.text isEqualToString:@""] || [self.textFieldForNote.text isEqualToString:@""])
    {
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your name and note" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errAlert show];
    }
    else
    {
        sqlite3 *db=[AppDelegate getNewDBConnection];
        sqlite3_stmt *stmt=nil;
        const char *sql=[[NSString stringWithFormat:@"insert into notes values ('%@', '%@')", self.textFieldForName.text, self.textFieldForNote.text] UTF8String];
        
        int status = sqlite3_exec(db, sql, nil, nil, nil);
        NSLog(@"SQLITE Querry Status: %d", status);
        
        if(status != SQLITE_OK)
        {
            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Preparing statement, try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            if(status == SQLITE_CONSTRAINT)
            {
                errAlert.message = @"Cannot add multiple notes for same user, try editing old one of yours.";
            }
            [errAlert show];
        }
        else
        {
            sqlite3_finalize(stmt);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        sqlite3_close(db);
    }
}

- (IBAction)fnForNavigationCancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
