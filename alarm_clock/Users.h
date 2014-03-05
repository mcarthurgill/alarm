//
//  Users.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/3/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSNumber * friend_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSSet *alarms;
@property (nonatomic, retain) Users *friend;

@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addAlarmsObject:(NSManagedObject *)value;
- (void)removeAlarmsObject:(NSManagedObject *)value;
- (void)addAlarms:(NSSet *)values;
- (void)removeAlarms:(NSSet *)values;
- (NSSet *)getAlarms;
- (NSMutableArray *)getCurrentlyOnAlarms;

@end
