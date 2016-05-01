//
//  RestaurantViewController.h
//  iMunch
//
//  Created by Ananth Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitle;
@property (weak, nonatomic) IBOutlet UILabel *restaurantRating;

@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantReview;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage1;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage2;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage3;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) NSDictionary *restaurantCurrent;

@end
