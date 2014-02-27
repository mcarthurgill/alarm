//
//  ALAlarmTableViewController.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 2/26/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "ALAlarmTableViewController.h"
#import "ALNewAlarmViewController.h"

@interface ALAlarmTableViewController ()

@end

@implementation ALAlarmTableViewController

@synthesize alarmList;
@synthesize setAlarms;

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
    alarmList = [[NSMutableArray alloc] initWithObjects:@"7:30 AM", nil];
    setAlarms = [[NSMutableArray alloc] init];
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
    [alarmLabel setText:[alarmList objectAtIndex:indexPath.row]];
    
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
    
    if (switchControl.on) {
        [setAlarms addObject:label];
    } else {
        [setAlarms removeObject:label];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (IBAction)addAlarmAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ALNewAlarmViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"newAlarmViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) viewController:(ALNewAlarmViewController *)controller didFinishSettingAlarm:(NSString *)time {
    [alarmList addObject:time];
    [self.tableView reloadData];
}


- (IBAction)editAlarmAction:(id)sender {
}

@end
