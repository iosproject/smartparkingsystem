//
//  ParkingLot.h
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingLot : NSObject

@property (strong, nonatomic) NSString *lotId;
@property (strong, nonatomic) NSString *name;
@property int maxNumberSpots;
@property NSMutableArray *parkingSpots;

-(id)initWithId:(NSString *)anId;
-(id)initWithId:(NSString *)anId andName:(NSString *)aName andMax:(int)max;

@end
