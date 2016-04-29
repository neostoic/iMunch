//
//  YelpAPIModel.m
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/28/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "YelpAPIModel.h"
#import "YelpAPISearch.h"

// Filename for data - favorites plist
static NSString *const kFavoritesPList = @"kFavoritesPList";

// class extension
@interface YelpAPIModel ()

// private properties
@property (strong, nonatomic) NSArray* businessArray;
@property (strong, nonatomic) NSMutableArray* favoritesArray;
@property (strong, nonatomic) NSMutableArray* resultsArray;
@property (strong, nonatomic) NSString* filepath;

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
- (void) save {
    [self.favoritesArray writeToFile: self.filepath atomically:YES];
}- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filepath = [documentsDirectory stringByAppendingPathComponent:kFavoritesPList];
        _favoritesArray = [NSMutableArray arrayWithContentsOfFile:_filepath];
        if (!_favoritesArray) {
            _favoritesArray = [[NSMutableArray alloc]init];
        }
    }
    return self;
}
- (NSMutableArray*) searchResults:(NSString *)term location:(NSString *)location {
    YelpAPISearch *APISample = [[YelpAPISearch alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) {
        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    
    NSArray* searchResults = [APISample getAllBusiness];
    NSMutableArray *toReturn = [NSMutableArray arrayWithArray:searchResults];
    _resultsArray = toReturn;
    return toReturn;
}
-(NSUInteger) numberOfRestaurants {
    NSString *defaultTerm = @"restaurants";
    NSString *defaultLocation = @"90007";
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
    return [self.businessArray count];
}
-(NSMutableArray* ) allRestaurants {
    NSString *defaultTerm = @"restaurants";
    NSString *defaultLocation = @"90007";
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
    NSArray* searchResults = [APISample getAllBusiness];
    NSMutableArray *toReturn = [NSMutableArray arrayWithArray:searchResults];
    return toReturn;
}
- (NSDictionary *) restaurantAtIndex:(NSUInteger)index {
    return [self.businessArray objectAtIndex:index];
}
- (void) insertFavorite:(NSDictionary *)restaurant {
    [self.favoritesArray addObject:restaurant];
    [self save];
}
- (void) removeFavoriteAtIndex:(NSUInteger)index {
    if (index < self.numberOfFavorites) {
         [self.favoritesArray removeObjectAtIndex:index];
    }
    [self save];
   
}
- (NSUInteger) numberOfFavorites {
    return [self.favoritesArray count];
}
- (NSDictionary *) favoriteAtIndex:(NSUInteger)index {
    return self.favoritesArray[index];
}



@end
