//
//  ALAlarmTableViewController.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 2/26/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "ALAlarmTableViewController.h"
#import "ALNewAlarmViewController.h"
#import "ALAppDelegate.h"

@interface ALAlarmTableViewController ()

@end

@implementation ALAlarmTableViewController

@synthesize alarmList;
@synthesize setAlarms;
@synthesize managedObjectContext;
@synthesize currentUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ALAppDelegate *appDelegate = (ALAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *users = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    currentUser = (Users *)[users objectAtIndex:0];
    NSSet *alarms = [currentUser getAlarms];
    alarmList = [[NSMutableArray alloc] initWithArray:[alarms allObjects]];
    setAlarms = [[NSMutableArray alloc] init];
    NSArray *setAlarmObjects = [[NSArray alloc] initWithArray:[currentUser getCurrentlyOnAlarms]];
    for (Alarms *myAlarm in setAlarmObjects) {
        [setAlarms addObject:[myAlarm getTime]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return alarmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UISwitch* onSwitch = (UISwitch*)[cell.contentView viewWithTag:2];
    UILabel *alarmLabel = (UILabel*)[cell.contentView viewWithTag:1];
    [alarmLabel setText:[[alarmList objectAtIndex:indexPath.row] getTime]];

    if ([setAlarms containsObject:alarmLabel.text]) {
        [onSwitch setOn:YES animated:YES];
    } else {
        [onSwitch setOn:NO animated:YES];
    }
    
    //I multiplied the tag by -1 because I was getting errors
    [cell.contentView setTag:indexPath.row * -1];

    [onSwitch addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];

    return cell;
}

- (void) onSwitchChanged:(id)sender {
    UISwitch* switchControl = (UISwitch*)sender;
    
    NSString *label = [(UILabel*)[[[switchControl superview] viewWithTag:[[switchControl superview] tag]] viewWithTag:1] text];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Alarms" inManagedObjectContext:managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@ && time == %@", currentUser.user_id, label];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];

    if ([results count] == 1) {
        if (switchControl.on) {
            [setAlarms addObject:label];
            [[results objectAtIndex:0] turnOn];
        } else {
            [setAlarms removeObject:label];
            [[results objectAtIndex:0] turnOff];
        }
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"****ahhh we got back too many results in on switch changed******");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (IBAction)addAlarmAction:(id)sender {
    [self turnEditingOff]; 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ALNewAlarmViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"newAlarmViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) viewController:(ALNewAlarmViewController *)controller didFinishSettingAlarm:(NSString *)time {
    Alarms *newAlarm = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Alarms"
                     inManagedObjectContext:managedObjectContext];
    BOOL match = NO;
    for ( Alarms* myAlarm in alarmList) {
        if ([[myAlarm getTime] isEqualToString:time]) {
            match = YES;
            [newAlarm turnOn];
            NSError *error;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
    
    if (!match) {
        [newAlarm setValue:time forKey:@"time"];
        [currentUser addAlarmsObject:newAlarm];
        [alarmList addObject:newAlarm];
    }
    
    [setAlarms addObject:time];
    [self.tableView reloadData];
}


- (IBAction)editAlarmAction:(id)sender {
     NSArray *setAlarmObjects = [[NSArray alloc] initWithArray:[currentUser getCurrentlyOnAlarms]];
    NSLog(@"setAlarmObjects: %@", setAlarmObjects);
    NSLog(@"*******************");
    NSLog(@"alarmList: %@", alarmList);
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }else {
        [self.tableView setEditing:YES animated:YES]; 
    }
}

- (void) turnEditingOff {
    [self.tableView setEditing:NO animated:YES];
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
         NSString *time = [(UILabel*)[cell viewWithTag:1] text];
         
         NSFetchRequest *request = [[NSFetchRequest alloc] init];
         [request setEntity:[NSEntityDescription entityForName:@"Alarms" inManagedObjectContext:managedObjectContext]];
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@ && time == %@", currentUser.user_id, time];
         [request setPredicate:predicate];
         
         NSError *error = nil;
         NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
         
         if ([results count] == 1) {
            [setAlarms removeObject:time];
            [alarmList removeObject:[results objectAtIndex:0]];
            [currentUser removeAlarmsObject:[results objectAtIndex:0]];
         }
         if (![managedObjectContext save:&error]) {
             NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
         }
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
}



/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
