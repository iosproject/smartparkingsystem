//
//  ViewController.m
//  SmartParkingSystem
//
//  Created by Computer Science on 3/24/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ViewController.h"
#define kspQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController ()

@end

@implementation ViewController

@synthesize parkingLots = _parkingLots, myLabel = _myLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_myLabel setText:@"Loading..."];
    // ParkingLot *lot = [[ParkingLot alloc] initWithId:@"2"];
    // [self.parkingLots addObject:lot];
    [self fetchParkingLots];
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* parkingSpots = [json objectForKey:@"parking_lots"];
    
    //NSLog(@"parking_lots: %@", parkingSpots);
    //NSLog(@"parking_lots count: %@", [NSString stringWithFormat:@"%d",[parkingSpots count]]);
    NSMutableString *screentext = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [parkingSpots count]; i++) {
        
        NSDictionary *lot = [parkingSpots objectAtIndex:i];
        NSString *lot_id = [lot objectForKey:@"id"];
        NSString *lot_name = [lot objectForKey:@"name"];
        NSString *trimmedString = [[lot objectForKey:@"max_number_of_spots"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        int max_spots = [trimmedString intValue];
        [screentext appendString:[NSString stringWithFormat:@"id: %@, name: %@, max spots: %d\n",lot_id, lot_name, max_spots]];
        
        NSLog(@"%@", [NSString stringWithFormat:@"id: %@, name: %@, max spots: %d",lot_id, lot_name, max_spots] );
        
        
    }
    
    [_myLabel setText:screentext];
}

- (void) fetchParkingLots {
    
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost/kean_smart_park/parking_lot_json.php"]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
