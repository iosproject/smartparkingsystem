//
//  MapViewController.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 4/1/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

// helvetica neue

#import "MapViewController.h"

#define kspQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initilizeView];
}

- (void)initilizeView {
    
    [self fetchParkingSpots];
    self.lotLabel.text = self.lotName;
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    self.parkingSpots = [json objectForKey:@"parking_spots"];
    
    // NSLog(@"parking_lots: %@", parkingLots);
    NSLog(@"fetched %@ parking spots", [NSString stringWithFormat:@"%d",[self.parkingSpots count]]);
    
    NSMutableString *dataString = [[NSMutableString alloc] init];
    
    [dataString appendString:[NSString stringWithFormat:@"%@ has %d spots of available of type %@", self.lotName, [self.parkingSpots count], self.userType]];
    
    self.lotData.text = dataString;
    /*
    int yPos = 100;
    NSDictionary *lot = nil;
    NSString *lot_name = nil;
    for (int i = 0; i < [self.parkingLots count]; i++) {
        
        // grab a lot from the array
        lot = [self.parkingLots objectAtIndex:i];
        
        // get the lot's name
        lot_name = [lot objectForKey:@"name"];
        
        // create a button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(onSelect:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:lot_name forState:UIControlStateNormal];
        
        // place the button on the screen
        yPos += 50;
        button.frame = CGRectMake(80.0, yPos, 160.0, 40.0);
        [self.view addSubview:button];
        
    }
     */
}

- (void) fetchParkingSpots {
    
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/kean_smart_park/parking_spot_json.php?parking_lot_id=%@&type=%@", self.lotId, self.userType]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}



@end
