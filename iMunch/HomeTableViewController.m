//
//  HomeTableViewController.m
//  iMunch
//
//  Created by Ananth Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "HomeTableViewController.h"
#import "YelpAPIModel.h"
#import "RestaurantViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface HomeTableViewController ()
// private properties

@property(strong, nonatomic) YelpAPIModel *model;
@property(strong, nonatomic) NSDictionary *currentRestaurant;
@property(strong, nonatomic) NSString* currentAddress;
@end


@implementation HomeTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.model = [YelpAPIModel sharedModel];
    
    _startBusinesses = [[NSMutableArray alloc]init];
    
    // Call the INTULocationManager callback method to find current location
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                 // currentLocation contains the device's current location.
                                                 
                                                 // Reverse geocode lat and long to address
                                                 
                                                 
                                                 CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
                                                 [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
                                                  {
                                                      if (!(error))
                                                      {
                                                          CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                                          NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                                          NSString *Address = [[NSString alloc]initWithString:locatedAt];
                                                          // Add to businesses array
                                                          [self.startBusinesses addObjectsFromArray:[self.model searchResults:@"restaurants" location:Address]];
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^ {
                                                              [self.tableView reloadData];
                                                          });
                                                      }
                                                      
                                                      else
                                                      {
                                                        
                                                      }
                                                  }];
                                                
                                                 
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                 // However, currentLocation contains the best location available (if any) as of right now,
                                                 // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                                
                                             }
                                             else {
                                                 // An error occurred, more info is available by looking at the specific status returned.
                                                
                                             }
                                         }];
    

    
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (IBAction)loginButtonClicked:(id)sender {
    // This will log the user in to Facebook
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             //NSLog(@"Process error");
         } else if (result.isCancelled) {
             //NSLog(@"Cancelled");
         } else {
             //NSLog(@"Logged in");
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.startBusinesses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    // Grab restaurants from businesses array
    
    NSDictionary* restaurant = [self.startBusinesses objectAtIndex:indexPath.row];
    cell.textLabel.text = restaurant[kNameKey];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // get current cell and send information to restaurant view
    _currentRestaurant = [self.startBusinesses objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Send information to restaurant view
    if ([segue.identifier  isEqual: @"restaurantSegue"]) {
        RestaurantViewController *vcDestination = segue.destinationViewController;
        vcDestination.restaurantCurrent = [self currentRestaurant];
    }
}


@end
