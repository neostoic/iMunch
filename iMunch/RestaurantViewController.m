//
//  RestaurantViewController.m
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "RestaurantViewController.h"
#import "YelpAPIModel.h"

@interface RestaurantViewController ()


@end

@implementation RestaurantViewController
- (IBAction)goBack:(id)sender {
    // Back button
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Parse through location and get address string
    NSDictionary* location = [_restaurantCurrent objectForKey:@"location"];
    NSArray* display_address = [location objectForKey:kLocationKey];
    NSString* address = [[display_address valueForKey:@"description"] componentsJoinedByString:@" "];
    _restaurantAddress.text = address;
    
    // Set the rest from keys
   _restaurantTitle.text = [_restaurantCurrent objectForKey:kNameKey];
    NSString* rating = [[_restaurantCurrent objectForKey:kRatingKey] stringValue];
    _restaurantRating.text = [_restaurantRating.text stringByAppendingString:rating];
    _restaurantReview.text = [_restaurantCurrent objectForKey:kReviewKey];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
