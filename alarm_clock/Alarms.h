//
//  Alarms.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/3/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Users;

@interface Alarms : NSManagedObject

@property (nonatomic, retain) NSNumber * alarm_id;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic) NSNumber * on;
@property (nonatomic, retain) Users *user;

-(NSString *)getTime;
-(void)turnOn;
-(void)turnOff; 

@end
