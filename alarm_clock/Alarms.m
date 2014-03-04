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
@dynamic hour;
@dynamic minute;
@dynamic user_id;
@dynamic user;
@dynamic on;

-(NSString *)getTime {
    NSMutableString *time = [[NSMutableString alloc] init];
    NSString *minutes = [self.minute stringValue];
    NSNumber *hourNumber = [NSNumber numberWithInt:(int)([self.hour integerValue] - 12)];
    NSString *hours = [self.hour stringValue];
    NSString *ending = @" AM";
    
    if ([self.hour integerValue] == 0) {
        [time appendString:@"12"];
    } else if ([self.hour integerValue] < 11) {
        [time appendString:hours];
    } else {
        [time appendString:[hourNumber stringValue]];
        ending = @" PM";
    }
    
    [time appendString:@":"];
    [time appendString:minutes];
    [time appendString:ending];
    return time;
}

-(void)turnOn {
    self.on = [NSNumber numberWithBool:YES];
}

-(void)turnOff {
    self.on = [NSNumber numberWithBool:NO];
}

-(NSNumber *)isOn {
    return self.on;
}

@end
