//
//  CalendarViewController.h
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar/FSCalendar.h"

@interface CalendarViewController : UIViewController <FSCalendarDataSource, FSCalendarDelegate>

@property (strong, nonatomic) NSDictionary *gListData;

@end
