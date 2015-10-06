//
//  ViewController.m
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import "ViewController.h"
#import "AppUtility.h"
#import "TableViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSDictionary *gListData;
@end

@implementation ViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Listener

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self okButtonListener:nil];
    return YES;
}

- (IBAction)okButtonListener:(UIButton *)sender {
    
    __block UIAlertView *loadingView;
    dispatch_async(dispatch_get_main_queue(), ^{
        loadingView = [[UIAlertView alloc] initWithTitle:@"Loading ..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [loadingView show];
    });
    
    [AppUtility getDataFrom:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", self.textField.text] completion:^(NSDictionary *dict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView dismissWithClickedButtonIndex:0 animated:YES];
        });
     
        if (!error) {
            if ([dict.allKeys containsObject:@"errors"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[dict[@"errors"] description]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                });
            }
            else
            {
                if ([dict[@"total_count"] intValue] <= 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"No results was found"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    });
                }
                else
                {
                    self.gListData = dict;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"toListView" sender:sender];
                    });
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:error.description
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            });
        }
    }];
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toListView"])
    {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        TableViewController *destCon = [segue destinationViewController];
        destCon.gListData = self.gListData;
    }
}


@end
