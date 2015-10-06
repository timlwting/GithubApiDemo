//
//  TableViewController.m
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSDictionary *selectedGListData;

@end

@implementation TableViewController

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Repos";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.gListData[@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *item = [(NSArray *)self.gListData[@"items"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = item[@"url"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedGListData = [(NSArray *)self.gListData[@"items"] objectAtIndex:indexPath.row];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"toCalendarView" sender:nil];
    });

}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toCalendarView"])
    {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        TableViewController *destCon = [segue destinationViewController];
        destCon.gListData = self.selectedGListData;
    }
}

@end
