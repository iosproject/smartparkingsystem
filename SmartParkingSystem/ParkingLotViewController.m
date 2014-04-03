//
//  ParkingLotViewController.m
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 4/1/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ParkingLotViewController.h"
#import "MapViewController.h"

#define kspQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ParkingLotViewController ()

@property (strong, nonatomic) NSArray *parkingLots;

@end

@implementation ParkingLotViewController

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
    if ([self.userType isEqualToString:@"STUDENT"]) {
        
        self.viewLabel.text = @"Student Parking Lots";
        
    } else if ([self.userType isEqualToString:@"FACULTY"]) {
        
        self.viewLabel.text = @"Faculty Parking Lots";
        
    } else if ([self.userType isEqualToString:@"VISITOR"]) {
        
        self.viewLabel.text = @"Visitor Parking Lots";
        
    } else if ([self.userType isEqualToString:@"HANDICAP"]) {
        
        self.viewLabel.text = @"Handicap Parking Lots";
    }
    
    [self fetchParkingLots];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    self.parkingLots = [json objectForKey:@"parking_lots"];
    
    // NSLog(@"parking_lots: %@", parkingLots);
    NSLog(@"fetched %@ parking lots", [NSString stringWithFormat:@"%d",[self.parkingLots count]]);
    
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
}

- (void) fetchParkingLots {
    
     dispatch_async(kspQueue, ^{
         NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.kean.skyfz.com/parking/parking_lot_json.php"]];
         [self performSelectorOnMainThread:@selector(fetchedData:)
                                withObject:data waitUntilDone:YES];
     });
    
}

- (IBAction)onSelect:(id)sender {
    
    [self performSegueWithIdentifier:@"showMap" sender:sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button = sender;
    NSDictionary *lot = nil;
    NSString *lot_name = nil;
    
    for (int i = 0; i < [self.parkingLots count]; i++) {
        
        // grab a lot from the array
        lot = [self.parkingLots objectAtIndex:i];
        
        // get the lot's name
        lot_name = [lot objectForKey:@"name"];
        
        if([button.titleLabel.text isEqualToString:lot_name]) {
            
            NSLog(@"map segue for lot %@", lot_name);
            MapViewController *mvc = [segue destinationViewController];
            mvc.lotId = [lot objectForKey:@"id"];
            mvc.lotName = lot_name;
            mvc.userType = self.userType;
            break;
            
        }
    }
    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        // pass variables to the next view controller
    
    }
}

@end
