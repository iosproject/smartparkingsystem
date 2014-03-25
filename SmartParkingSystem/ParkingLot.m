//
//  ParkingLot.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 3/25/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ParkingLot.h"
#import "ParkingSpot.h"

#define kspQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation ParkingLot

@synthesize lotId, name, maxNumberSpots;

-(id)initWithId:(NSString *)anId {
    
    self = [super init];
    
    if (self) {
        
        self.lotId = anId;
        [self fetchParkingSpots];
    }
    
    return self;
}

-(id)initWithId:(NSString *)anId andName:(NSString *)aName andMax:(int)max {
    
    self = [super init];
    
    if (self) {
        
        self.lotId = anId;
        self.name = name;
        self.maxNumberSpots = max;
        [self fetchParkingSpots];
    }
    
    return self;
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* parkingSpots = [json objectForKey:@"parking_spots"]; //2
    
    NSLog(@"parking_spots: %@", parkingSpots); //3
}

- (void) fetchParkingSpots {
    
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/kean_smart_park/parking_spot_json.php?parking_lot_id=%@",self.lotId]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

@end
