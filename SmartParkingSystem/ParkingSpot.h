//
//  ParkingSpot.h
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingSpot : NSObject

@property (strong, nonatomic) NSString *spotId;
@property (strong, nonatomic) NSString *lotId;
@property (strong, nonatomic) NSString *type;
@property int position_x;
@property int position_y;
@property int available;

- (BOOL) spotIsAvailable;

- (id) initWithSpotId:(NSString *)aSpotId
             andLotId:(NSString *)aLotId
              andType:(NSString *)aType
         andAvailable:(int)isAvailable
         andPositionX:(int)x
         andPositionY:(int)y;
@end
