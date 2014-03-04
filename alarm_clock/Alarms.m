//
//  Alarms.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/3/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "Alarms.h"
#import "Users.h"


@implementation Alarms

@dynamic alarm_id;
@dynamic time;
@dynamic user_id;
@dynamic user;
@dynamic on;

-(NSString *)getTime {
    return self.time; 
}

-(void)turnOn {
    self.on = [NSNumber numberWithBool:YES];
}

-(void)turnOff {
    self.on = [NSNumber numberWithBool:NO];
}

@end
