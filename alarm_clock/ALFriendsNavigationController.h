//
//  ALFriendsNavigationController.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/5/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"
#import "ALAppDelegate.h"

@interface ALFriendsNavigationController : UINavigationController

@property (nonatomic, strong) Users *currentUser;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


@end
