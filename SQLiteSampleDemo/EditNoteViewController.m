//
//  EditNoteViewController.m
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import "EditNoteViewController.h"
#import "AppDelegate.h"

@interface EditNoteViewController ()

@end

@implementation EditNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dictionaryForNote = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.textFieldForName.text = [self.dictionaryForNote objectForKey:@"SubmittedBy"];
    self.textFieldForNote.text = [self.dictionaryForNote objectForKey:@"Note"];
    
    self.textFieldForName.enabled = NO;
    self.textFieldForNote.enabled = NO;
    self.buttonForEditNote.tag = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)fnForNavigationEditButtonPressed:(id)sender
{
    if(self.buttonForEditNote.tag == 0)
    {
        self.buttonForEditNote.tag = 1;
        [self.buttonForEditNote setTitle:@"DONE"];
        self.textFieldForNote.enabled = YES;
        self.textFieldForNote.textColor = [UIColor blackColor];
    }
    else
    {
        if(![self.textFieldForNote.text isEqualToString:@""])
        {
            sqlite3 *db=[AppDelegate getNewDBConnection];
            sqlite3_stmt *stmt=nil;
            const char *sql=[[NSString stringWithFormat:@"UPDATE Notes SET Note='%@' WHERE SubmittedBy='%@'", self.textFieldForNote.text, self.textFieldForName.text] UTF8String];
            
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
            
            self.buttonForEditNote.tag = 0;
            [self.buttonForEditNote setTitle:@"EDIT"];
            self.textFieldForNote.textColor = [UIColor lightGrayColor];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter note" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errAlert show];
        }
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
