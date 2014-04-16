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
    
    //start loading, show activity indicator
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    // Do any additional setup after loading the view.
    if ([self.userType isEqualToString:@"STUDENT"]) {
        
        //self.viewLabel.text = @"Student Parking Lots";
        
    } else if ([self.userType isEqualToString:@"FACULTY"]) {
        
       // self.viewLabel.text = @"Faculty Parking Lots";
        
    } else if ([self.userType isEqualToString:@"VISITOR"]) {
        
       // self.viewLabel.text = @"Visitor Parking Lots";
        
    } else if ([self.userType isEqualToString:@"HANDICAP"]) {
        
        //self.viewLabel.text = @"Handicap Parking Lots";
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
    // NSLog(@"fetched %@ parking lots", [NSString stringWithFormat:@"%d",[self.parkingLots count]]);
    
    int yPos = 110;
    int xPos= 16;
    NSDictionary *lot = nil;
    NSString *lot_name = nil;
    int numberOfLots = [self.parkingLots count];
    NSString *lot_Id = nil;
    NSMutableString *fileName = [[NSMutableString alloc]init];
    
    for (int i = 0; i < numberOfLots; i++) {
        
        
        // grab a lot from the array
        lot = [self.parkingLots objectAtIndex:i];
        
        // get the lot's name
        lot_name = [lot objectForKey:@"name"];
        
        // get the lot's id
        lot_Id = [lot objectForKey:@"id"];
        [fileName appendString: lot_Id];
        [fileName appendString:@".png"];

        
        // create a button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(onSelect:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:lot_name forState:UIControlStateNormal];
        //[button setBackgroundColor:[UIColor greenColor]];
        [button setBackgroundImage:[UIImage imageNamed:fileName]
                            forState:UIControlStateNormal];
        // NSLog(@"fileName = %@", fileName);
        [fileName setString:@""];
        // remove the button since hiding it doesn't work
        [button.titleLabel removeFromSuperview];
        // put back when you're done
        //[button addSubview:button.titleLabel];
        
        //create label on top for the avai;lable parking lot
        UILabel *bgLabel = [[UILabel alloc]init];
        [bgLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"label_bg.png"]]];
        
        UILabel *topLabel = [[UILabel alloc]init];
        [topLabel setTextColor:[UIColor whiteColor]];
        [topLabel setFont:[UIFont fontWithName:@"Times New Roman" size:15.0]];
        
        UILabel *bottomLabel = [[UILabel alloc]init];
        [bottomLabel setTextColor:[UIColor whiteColor]];
        [bottomLabel setFont:[UIFont fontWithName:@"Times New Roman" size:12.0]];
        [bottomLabel setText: lot_name];
        
        if ([self.userType isEqualToString:@"STUDENT"]) {
            
            [topLabel setText: [lot objectForKey:@"student_spots_available"]];
            
        } else if ([self.userType isEqualToString:@"FACULTY"]) {
            
            [topLabel setText: [lot objectForKey:@"faculty_spots_available"]];
            
        } else if ([self.userType isEqualToString:@"VISITOR"]) {
            
            [topLabel setText: [lot objectForKey:@"visitor_spots_available"]];
            
        } else if ([self.userType isEqualToString:@"HANDICAP"]) {
            
            [topLabel setText: [lot objectForKey:@"handicap_spots_available"]];
           
        }

        // place the button on the screen
        
        button.frame = CGRectMake(xPos, yPos, 80.0, 80.0);
        bgLabel.frame = CGRectMake(xPos+50, yPos-25, 40.0, 40.0);
        topLabel.frame = CGRectMake(xPos+55, yPos-25, 30.0, 30.0);
        bottomLabel.frame = CGRectMake(xPos, yPos+78, 80.0,30.0);
        [self.view addSubview:button];
        [self.view addSubview:bgLabel];
        [self.view addSubview:topLabel];
        [self.view addSubview:bottomLabel];
        xPos += 105;
        if(xPos >= 315) {
            xPos = 16;
            yPos+= 130;
        }
        
        
    }
    
    // done hide activity indicator
    [self.activityIndicator stopAnimating];
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
            
            // NSLog(@"map segue for lot %@", lot_name);
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
