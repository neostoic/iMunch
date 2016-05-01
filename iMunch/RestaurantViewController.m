//
//  RestaurantViewController.m
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "RestaurantViewController.h"
#import "YelpAPIModel.h"
#import "FacebookCollectionViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface RestaurantViewController ()
// private properties
@property(strong, nonatomic) YelpAPIModel* model;

@end

@implementation RestaurantViewController
- (IBAction)goBack:(id)sender {
    // Back button
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goFacebook:(id)sender {
    [self performSegueWithIdentifier:@"FacebookSegue" sender:self];
}
- (IBAction)addFavorite:(id)sender {
    [self.model insertFavorite:_restaurantCurrent];
    NSString* part1 = @"Congratulations! You just added ";
    NSString* part2 = [_restaurantCurrent objectForKey:kNameKey];
    NSString* part3 = @" to your favorites!";
    NSString* messageAlert = [NSString stringWithFormat:@"%@%@%@", part1, part2, part3];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Favorited!" message:messageAlert preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    
    self.model = [YelpAPIModel sharedModel];
    
    // Output document persistence folder
//#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager]
//                                        URLsForDirectory:NSDocumentDirectory
//                                        inDomains: NSUserDomainMask] lastObject]);
//#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"FacebookSegue"]) {
        if ([FBSDKAccessToken currentAccessToken]) {
            
            // grab coordinates from current restaurant
            NSDictionary* location = [self.restaurantCurrent objectForKey:@"location"];
            NSDictionary* coordinate = [location objectForKey:@"coordinate"];
            NSString* longitude = [coordinate objectForKey:@"longitude"];
            NSString * latitude = [coordinate objectForKey:@"latitude"];
            NSArray *coordinates = [[NSArray alloc] initWithObjects:longitude, latitude, nil];
            NSString *center = [coordinates componentsJoinedByString:@","];
            
            
            // make an API request to search for the corresponding Facebook page
            NSMutableDictionary *params2 = [NSMutableDictionary dictionaryWithCapacity:5L];
            
            [params2 setObject:center forKey:@"center"];
            [params2 setObject:@"page" forKey:@"type"];
            [params2 setObject:@"id" forKey: @"fields"];
            [params2 setObject:@"10" forKey:@"distance"];
            [params2 setObject:[self.restaurantCurrent objectForKey:kNameKey] forKey:@"q"];
            [params2 setObject:@"1" forKey:@"limit"];
            
            // store in dictionary
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/search" parameters:params2 HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                //NSLog(@"result %@",result);
                
                id newOne =  [result objectForKey: @"data"];
                
                NSDictionary* one = newOne[0];
                
                // Get images from that particular page using Page ID
                NSString *path1 = @"/";
                NSString* path2 = [one objectForKey:@"id"];
                NSString* path3 = @"/photos";
                NSString* path = [NSString stringWithFormat:@"%@%@%@", path1, path2, path3];
                //NSLog(@"%@", path);
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1L];
                
                [params setObject:@"id" forKey:@"fields"];
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:path
                                              parameters:params
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    // Handle the result
                    
                    //  NSLog(@"%@", result);
                    
                    id newOne =  [result objectForKey: @"data"];
                    NSArray *allImagesArray = newOne;
                    NSMutableArray *allImages = [[NSMutableArray alloc] init];
                    
                    for (int i  = 0; i < [allImagesArray count]; i++) {
                        [allImages addObject:[allImagesArray[i] objectForKey:@"id"]];
                    }
                      NSLog(@"%lu", (unsigned long)[allImages count]);
                    
                    UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
                    FacebookCollectionViewController *facebookController = (FacebookCollectionViewController*)[navController topViewController];
                    facebookController.images = allImages;
                    
                }];
            }];
            
        }
       
    }

}


@end
