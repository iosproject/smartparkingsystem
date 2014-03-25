//
//  ParkingSpot.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ParkingSpot.h"

@implementation ParkingSpot

@synthesize spotId, type, position_x, position_y, available;

- (id) initWithSpotId:(NSString *)aSpotId
              andType:(NSString *)aType
         andAvailable:(NSInteger *)isAvailable
         andPositionX:(NSInteger *)x
         andPositionY:(NSInteger *)y

{
    self = [super init];
    
    if (self) {
        self.spotId = aSpotId;
        self.type = aType;
        self.available = isAvailable;
        self.position_x = x;
        self.position_y = y;
    }
    
    return self;
}
@end
