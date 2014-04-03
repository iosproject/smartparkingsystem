//
//  ParkingLot.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ParkingLot.h"
#import "ParkingSpot.h"

@implementation ParkingLot

-(id)initWithId:(NSString *)anId {
    
    self = [super init];
    
    if (self) {
        
        self.lotId = anId;
    }
    
    return self;
}

-(id)initWithId:(NSString *)anId andName:(NSString *)aName andMax:(int)max {
    
    self = [super init];
    
    if (self) {
        
        self.lotId = anId;
        self.name = aName;
        self.maxNumberSpots = max;
        self.parkingSpots = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
