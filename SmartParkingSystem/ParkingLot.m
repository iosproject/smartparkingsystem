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

@synthesize lotId, name, maxNumberSpots, spots;

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
        self.spots = [[NSMutableArray alloc] init];
        [self fetchParkingSpots];
    }
    
    return self;
}

/*
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* parkingSpots = [json objectForKey:@"parking_spots"];
    
    //NSLog(@"parking_spots: %@", parkingSpots);
    
    for (int i = 0; i < [parkingSpots count]; i++) {
        
        NSDictionary *spot = [parkingSpots objectAtIndex:i];
        NSString *spot_id = [spot objectForKey:@"id"];
        NSString *lot_id = [spot objectForKey:@"parking_lot_id"];
        NSString *type = [spot objectForKey:@"type"];
        int posx = [[[spot objectForKey:@"position_x"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        int posy = [[[spot objectForKey:@"position_y"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        int available = [[[spot objectForKey:@"available"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        
        ParkingSpot *ps = [[ParkingSpot alloc] initWithSpotId:spot_id andLotId:lot_id andType:type andAvailable:available andPositionX:posx andPositionY:posy];
        [self.spots addObject:ps];
    }
}
*/
- (void) fetchParkingSpots {
    
    /*
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/kean_smart_park/parking_spot_json.php?parking_lot_id=%@",self.lotId]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
     */
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/kean_smart_park/parking_spot_json.php?parking_lot_id=%@",self.lotId]]];
    
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData: data
                          options:kNilOptions
                          error:&error];
    
    NSArray* parkingSpots = [json objectForKey:@"parking_spots"];
    
    NSLog(@"parking_spots: %@", parkingSpots);
    
    for (int i = 0; i < [parkingSpots count]; i++) {
        
        NSDictionary *spot = [parkingSpots objectAtIndex:i];
        NSString *spot_id = [spot objectForKey:@"id"];
        NSString *lot_id = [spot objectForKey:@"parking_lot_id"];
        NSString *type = [spot objectForKey:@"type"];
        int posx = [[[spot objectForKey:@"position_x"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        int posy = [[[spot objectForKey:@"position_y"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        int available = [[[spot objectForKey:@"available"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        
        ParkingSpot *ps = [[ParkingSpot alloc] initWithSpotId:spot_id andLotId:lot_id andType:type andAvailable:available andPositionX:posx andPositionY:posy];
        [self.spots addObject:ps];
    }
    
}

@end
