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
    //alarmList = [self sortAlarmList];
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
    
    NSString *hour = [[NSString alloc] init];
    NSString *min = [[NSString alloc] init];
    NSString *amOrPm = [[NSString alloc] init];
    
    hour = [self getHourFromString:label];
    min = [self getMinFromString:label];
    amOrPm = [self getAMorPMFromString:label];
    
    NSNumber *hourNumber = [self getHour:hour basedOnAMorPM:amOrPm];
    NSNumber *minNumber = [self getMinute:min];
    
    NSArray *results = [self getResultsForAlarmWithHour:hourNumber andMinute:minNumber];
    NSError *error = nil;

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
        } else {
            NSLog(@"I think I saved");
        }
    } else {
        NSLog(@"****ahhh we got back too many or zero results in on switch changed******");
    }
}

-(NSArray *)getResultsForAlarmWithHour:(NSNumber*)hourNumber andMinute:(NSNumber*)minNumber {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Alarms" inManagedObjectContext:managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@ && hour == %@ && minute == %@", currentUser.user_id, hourNumber, minNumber];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    return [managedObjectContext executeFetchRequest:request error:&error];
}

-(NSString *)getHourFromString:(NSString*)string {
    NSRange colon = [string rangeOfString:@":"];
    return [string substringWithRange:NSMakeRange(0, colon.location)];
}

-(NSString *)getMinFromString:(NSString*)string {
    NSRange space = [string rangeOfString:@" "];
    NSRange colon = [string rangeOfString:@":"];
    return [string substringWithRange:NSMakeRange(colon.location + 1, space.location - 2)];
}

-(NSString *)getAMorPMFromString:(NSString*)string {
    NSRange space = [string rangeOfString:@" "];
    return [string substringFromIndex:space.location + 1];
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

-(void) viewController:(ALNewAlarmViewController *)controller didFinishSettingAlarmWithHour:(NSInteger *)hour andMinute:(NSInteger *)minute {
    Alarms *newAlarm = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Alarms"
                     inManagedObjectContext:managedObjectContext];
    
    BOOL match = NO;
    for ( Alarms* myAlarm in alarmList) {
        if ([myAlarm.hour integerValue] == (int)hour && [myAlarm.minute integerValue] == (int)minute) {
            match = YES;
            [myAlarm turnOn];
            newAlarm = myAlarm;
        }
    }
    
    if (!match) {
        [newAlarm setValue:[NSNumber numberWithInt:(int)hour] forKey:@"hour"];
        [newAlarm setValue:[NSNumber numberWithInt:(int)minute] forKey:@"minute"];
        [currentUser addAlarmsObject:newAlarm];
        [alarmList addObject:newAlarm];
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else {
        NSLog(@"I think I saved");
    }
    
    [setAlarms addObject:[newAlarm getTime]];
    [self.tableView reloadData];
}


- (IBAction)editAlarmAction:(id)sender {
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
         
         NSString *hour = [[NSString alloc] init];
         NSString *min = [[NSString alloc] init];
         NSString *amOrPm = [[NSString alloc] init];
         
         hour = [self getHourFromString:time];
         min = [self getMinFromString:time];
         amOrPm = [self getAMorPMFromString:time];
         
         NSNumber *hourNumber = [self getHour:hour basedOnAMorPM:amOrPm];
         NSNumber *minNumber = [self getMinute:min];
         
         NSError *error = nil;
         NSArray *results = [self getResultsForAlarmWithHour:hourNumber andMinute:minNumber];
         
         if ([results count] == 1) {
            [setAlarms removeObject:time];
            [alarmList removeObject:[results objectAtIndex:0]];
            [currentUser removeAlarmsObject:[results objectAtIndex:0]];
         }
         if (![managedObjectContext save:&error]) {
             NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
         } else {
             NSLog(@"I think I saved");
         }
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
}

-(NSNumber*)getHour:(NSString*)hour basedOnAMorPM:(NSString*)amOrPm {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    if ([hour integerValue] == 12 && [amOrPm isEqualToString:@"AM"]) {
        return [NSNumber numberWithInt:0];
    } else if ([hour integerValue] == 12) {
        return [NSNumber numberWithInt:12];
    } else if ([amOrPm isEqualToString: @"PM"]) {
        NSInteger hourAsInt = [hour integerValue] + 12;
        return [NSNumber numberWithInt:hourAsInt];
    }
    return [f numberFromString:hour];
}

-(NSNumber*)getMinute:(NSString*)min {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if ([[min substringToIndex:1] isEqualToString:@"0"]) {
        min = [min substringFromIndex:1];
    }
    return [f numberFromString:min];
}


-(NSMutableArray *)sortAlarmList {
    NSMutableArray *sortedAlarms = [[NSMutableArray alloc] init];
//    
//    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
//    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
//    NSArray *sortedArray = [alarmList sortedArrayUsingDescriptors:descriptors];
//    
//    [sortedAlarms addObjectsFromArray:sortedArray];
//    for (Alarms *alarm in sortedAlarms) {
////        NSLog(@"time: %@", [alarm getTime]);
//    }
    return sortedAlarms;
}


@end
