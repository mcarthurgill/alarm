//
//  ALNewAlarmViewController.h
//  alarm_clock
//
//  Created by Joseph McArthur Gill on 2/26/14.
//  Copyright (c) 2014 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALNewAlarmViewController;

@protocol ALNewAlarmViewControllerDelegate <NSObject>
-(void) viewController:(ALNewAlarmViewController *)controller didFinishSettingAlarmWithHour:(NSInteger *)hour andMinute:(NSInteger *)minute;

@end

@interface ALNewAlarmViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) id <ALNewAlarmViewControllerDelegate> delegate;
@end
