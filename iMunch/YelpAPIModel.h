//
//  YelpAPIModel.h
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import <Foundation/Foundation.h>

// constants
static NSString * const kNameKey = @"name";
static NSString * const kReviewKey = @"snippet_text";
static NSString * const kLocationKey = @"display_address";
static NSString * const kRatingKey = @"rating";

@interface YelpAPIModel : NSObject

// public methods

+ (instancetype) sharedModel;
- (NSUInteger) numberOfRestaurants;
- (NSDictionary *) restaurantAtIndex: (NSUInteger) index;



@end
