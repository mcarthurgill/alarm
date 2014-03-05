//
//  ALFriendsNavigationController.m
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 3/5/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import "ALFriendsNavigationController.h"
#import "ALShowFriendViewController.h"
#import "ALContactsSelectorTableViewController.h"

@interface ALFriendsNavigationController ()

@end

@implementation ALFriendsNavigationController

@synthesize managedObjectContext;
@synthesize currentUser;

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


    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (currentUser.friend) {
        ALShowFriendViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"showFriendViewController"];
        [self pushViewController:vc animated:YES];
    } else {
        ALContactsSelectorTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"contactsSelectorTableViewController"];
        [self pushViewController:vc animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
