//
//  HomeViewController.m
//  SQLiteSampleDemo
//
//  Created by Sudhir Chavan on 23/07/13.
//  Copyright (c) 2013 Sudhir Chavan. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "AddNoteViewController.h"
#import "EditNoteViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize arrayForNotesData, tableViewForNotesDisplay;

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

-(void)viewWillAppear:(BOOL)animated
{    
    sqlite3 * db=[AppDelegate getNewDBConnection];
	sqlite3_stmt * stmt=nil;
	const char * sql="select * from notes";
    
	if(sqlite3_prepare_v2(db,sql,-1,&stmt,NULL)!=SQLITE_OK)
	{
		NSLog(@"ERROR PREPARING STATEMENT");
	}
	else
	{
        arrayForNotesData = nil;
        arrayForNotesData = [[NSMutableArray alloc] init];
        
		while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
            
            [dataDictionary setObject:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(stmt,0)] forKey:@"SubmittedBy"];
            [dataDictionary setValue:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(stmt,1)] forKey:@"Note"];
            
			[arrayForNotesData addObject:dataDictionary];
        }		
	}	
    sqlite3_close(db);
	[self.tableViewForNotesDisplay reloadData];
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)fnForNavigationBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fnForNavigationAddButtonPressed:(id)sender
{
    AddNoteViewController *addNoteVC = [[AddNoteViewController alloc] initWithNibName:@"AddNoteViewController" bundle:nil];
    [self presentViewController:addNoteVC animated:YES completion:nil];
}

#pragma mark - UITableView Delegate & Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayForNotesData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[arrayForNotesData objectAtIndex:indexPath.row] valueForKey:@"SubmittedBy"];
    cell.detailTextLabel.text = [[arrayForNotesData objectAtIndex:indexPath.row] valueForKey:@"Note"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditNoteViewController *editNoteVC = [[EditNoteViewController alloc] initWithNibName:@"EditNoteViewController" bundle:nil];
    editNoteVC.dictionaryForNote = [arrayForNotesData objectAtIndex:indexPath.row];
    
    [self presentViewController:editNoteVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Record to delete : %@", [[arrayForNotesData objectAtIndex:indexPath.row] objectForKey:@"SubmittedBy"]);
        
        sqlite3 *db=[AppDelegate getNewDBConnection];
        sqlite3_stmt *stmt=nil;
        const char *sql=[[NSString stringWithFormat:@"DELETE FROM Notes WHERE SubmittedBy='%@'", [[arrayForNotesData objectAtIndex:indexPath.row] objectForKey:@"SubmittedBy"]] UTF8String];
        
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
        }
        sqlite3_close(db);
        
        [self viewWillAppear:YES];
    }
}

@end
