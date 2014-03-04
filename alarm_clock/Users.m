//
//  Users.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/3/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "Users.h"
#import "Alarms.h"


@implementation Users

@dynamic friend_id;
@dynamic user_id;
@dynamic name;
@dynamic phone;
@dynamic alarms;

- (NSSet *)getAlarms {
    return self.alarms; 
}

- (NSMutableArray *)getCurrentlyOnAlarms {
    NSMutableArray *onAlarms = [[NSMutableArray alloc] init];
    for (Alarms *alarm in self.alarms) {
        if ([alarm.on isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [onAlarms addObject:alarm];
        }
    }
    return onAlarms;
}

@end
