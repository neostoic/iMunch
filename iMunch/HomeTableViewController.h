//
//  HomeTableViewController.h
//  iMunch
//
//  Created by Ananth Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "INTULocationManager.h"

@interface HomeTableViewController : UITableViewController

@property(strong, nonatomic) CLGeocoder* geocoder;
@property(strong, nonatomic) NSMutableArray *startBusinesses;

@end
