//
//  YelpAPIModel.m
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "YelpAPIModel.h"
#import "YelpAPISearch.h"

// class extension
@interface YelpAPIModel ()

// private properties
@property (strong, nonatomic) NSArray* businessArray;
@property (strong, nonatomic) NSMutableArray* favoritesArray;

@end

@implementation YelpAPIModel

+ (instancetype) sharedModel {
    static YelpAPIModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
-(NSUInteger) numberOfRestaurants {
    NSString *defaultTerm = @"restaurants";
    NSString *defaultLocation = @"90007";
    // __block NSDictionary *restaurant;
    YelpAPISearch *APISample = [[YelpAPISearch alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:defaultTerm location:defaultLocation completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) {
            //  restaurant = topBusinessJSON;
        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    
    _businessArray = [APISample getAllBusiness];
    _favoritesArray = [[NSMutableArray alloc]init];
    return [self.businessArray count];
}
- (NSDictionary *) restaurantAtIndex:(NSUInteger)index {
    return [self.businessArray objectAtIndex:index];
}
- (void) insertFavorite:(NSDictionary *)restaurant {
    [self.favoritesArray addObject:restaurant];
}
- (void) removeFavoriteAtIndex:(NSUInteger)index {
    if (index < self.numberOfFavorites) {
         [self.favoritesArray removeObjectAtIndex:index];
    }
   
}
- (NSUInteger) numberOfFavorites {
    return [self.favoritesArray count];
}
- (NSDictionary *) favoriteAtIndex:(NSUInteger)index {
    return self.favoritesArray[index];
}



@end
