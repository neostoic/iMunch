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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    for(NSString *key in [_restaurantCurrent allKeys]) {
//        NSLog(@"%@",[_restaurantCurrent objectForKey:key]);
//    }
    
  //  NSLog(@"%@", [_restaurantCurrent objectForKey:kNameKey]);
    
    
    
   _restaurantTitle.text = [_restaurantCurrent objectForKey:kNameKey];
   _restaurantRating.text = [[_restaurantCurrent objectForKey:kRatingKey] stringValue];
   // _restaurantAddress.text = [_restaurantCurrent objectForKey:kLocationKey];
//    //_restaurantAddress.text = address;
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
