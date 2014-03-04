//
//  ALAlarmTableViewController.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 2/26/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNewAlarmViewController.h"
#import "Users.h"
#import "Alarms.h"

@interface ALAlarmTableViewController : UITableViewController <ALNewAlarmViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *alarmList;
@property (nonatomic, strong) NSMutableArray *setAlarms;
@property (nonatomic, strong) Users *currentUser;
- (IBAction)editAlarmAction:(id)sender;
- (IBAction)addAlarmAction:(id)sender;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
