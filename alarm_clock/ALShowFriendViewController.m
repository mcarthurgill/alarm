//
//  ALShowFriendViewController.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/5/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "ALShowFriendViewController.h"
#import "ALAppDelegate.h"

@interface ALShowFriendViewController ()

@end

@implementation ALShowFriendViewController

@synthesize currentUser;
@synthesize friendNameLabel;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ALAppDelegate *appDelegate = (ALAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *users = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    currentUser = (Users *)[users objectAtIndex:0];
    
    //create friend
    Users *friend = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Users"
                     inManagedObjectContext:managedObjectContext];
    [friend setValue:@"Sarah Betack" forKey:@"name"];
    [friend setValue:@"2038033319" forKey:@"phone"];
    friend.friend = currentUser;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }


    [friendNameLabel setText:currentUser.friend.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
