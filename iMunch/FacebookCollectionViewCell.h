//
//  FacebookCollectionViewCell.h
//  iMunch
//
//  Created by Vishnu Venkateswaran on 4/30/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

-(void) setUpCell: (NSString* ) imageID;

@end
