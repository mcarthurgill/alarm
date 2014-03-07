//
//  ALShowFriendViewController.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/5/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface ALShowFriendViewController : UIViewController

@property (nonatomic, strong) Users *currentUser;
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
