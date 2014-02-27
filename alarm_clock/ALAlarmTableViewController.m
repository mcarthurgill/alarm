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
    if (![alarmList containsObject:time]) {
        [alarmList addObject:time];
        [setAlarms addObject:time];
    }else {
        [setAlarms addObject:time];
    }

    [self.tableView reloadData];
}


- (IBAction)editAlarmAction:(id)sender {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }else {
        [self.tableView setEditing:YES animated:YES]; 
    }
}


// // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     return YES;
// }
//


// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     if (editingStyle == UITableViewCellEditingStyleDelete) {
//         // Delete the row from the data source
//         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//         
//         if ([setAlarms containsObject:<#(id)#>]) {
//             <#statements#>
//         }
//     }
//     else if (editingStyle == UITableViewCellEditingStyleInsert) {
//     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     }
// }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
