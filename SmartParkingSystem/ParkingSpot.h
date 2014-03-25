//
//  ParkingSpot.h
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AVAILABLE = 1;
#define NOT_AVAILABLE = 0;

@interface ParkingSpot : NSObject

@property (strong, nonatomic) NSString *spotId;
@property (strong, nonatomic) NSString *type;
@property NSInteger *position_x;
@property NSInteger *position_y;
@property NSInteger *available;

@end
