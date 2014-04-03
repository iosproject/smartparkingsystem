//
//  ParkingSpot.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ParkingSpot.h"

@implementation ParkingSpot

- (id) initWithSpotId:(NSString *)aSpotId
             andLotId:(NSString *)aLotId
              andType:(NSString *)aType
         andAvailable:(int)isAvailable
         andPositionX:(int)x
         andPositionY:(int)y

{
    self = [super init];
    
    if (self) {
        self.spotId = aSpotId;
        self.lotId = aLotId;
        self.type = aType;
        self.available = isAvailable;
        self.position_x = x;
        self.position_y = y;
    }
    
    return self;
}

-(BOOL) spotIsAvailable {
    
    if(self.available == 1) {
        return YES;
    } else
        return NO;
}
@end
