//
//  CalendarViewController.m
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import "CalendarViewController.h"
#import "AppUtility.h"

@interface CalendarViewController ()
@property (weak , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) IBOutlet UIView *calendarView;
@property (strong, nonatomic) NSMutableSet *dateSet;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end


@implementation CalendarViewController

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.calendarView.bounds.size.width/2)];
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.center = self.view.center;
    [self.view addSubview:calendar];
    
    self.calendar = calendar;

    [self getGitEvent];
}

#pragma mark - FSCalendar

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar
{
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    return [self.dateSet containsObject:date];
}

#pragma mark - Private

- (void)getGitEvent
{
    __block UIAlertView *loadingView;
    dispatch_async(dispatch_get_main_queue(), ^{
        loadingView = [[UIAlertView alloc] initWithTitle:@"Loading ..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [loadingView show];
    });

    [AppUtility getDataFrom:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/commits", self.gListData[@"owner"][@"login"], self.gListData[@"name"]]  completion:^(NSDictionary *dict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView dismissWithClickedButtonIndex:0 animated:YES];
        });

        if ([dict isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = (NSArray *)dict;
            if (!self.dateSet) {
                self.dateSet = [[NSMutableSet alloc] initWithCapacity:0];
            }
            
            if (!self.dateFormatter) {
                self.dateFormatter = [[NSDateFormatter alloc] init];
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            }
            @try {
                [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                                                   fromDate:[self.dateFormatter dateFromString:obj[@"commit"][@"author"][@"date"]]];
                    
                    [self.dateSet addObject:[[NSCalendar currentCalendar] dateFromComponents:components]];
                    
                    
                }];
            }
            @catch (NSException *exception) {
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.calendar reloadData];
            });
        }
    }];
}

@end
