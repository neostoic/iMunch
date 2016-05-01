//
//  FacebookCollectionViewCell.m
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/30/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "FacebookCollectionViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookCollectionViewCell

- (void) setUpCell:(NSString *)imageID {
    NSString* part1 = @"/";
    NSString* photoID = [NSString stringWithFormat:@"%@%@", part1, imageID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5L];
    
    [params setObject:@"picture" forKey:@"fields"];
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:photoID
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        NSString* imageURL = [result objectForKey:@"picture"];
        self.imageVIew.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL   URLWithString:imageURL]]];
        
        //NSLog(@"%@", [result class]);
        
    }];
    
}

@end
