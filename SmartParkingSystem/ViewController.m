//
//  ViewController.m
//  SmartParkingSystem
//
//  Created by Computer Science on 3/24/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import "ViewController.h"
#import "ParkingLotViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize plm = _plm, myLabel = _myLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    [_myLabel setText:@"Loading..."];
    _plm = [[ParkingLotManager alloc] init];
    NSMutableString *dataString = [[NSMutableString alloc] init];
    [dataString appendString:@"Lots\n"];
    
    for (int i = 0; i < [_plm.parkingLots count]; i++) {
        
        NSString *myid = [NSString stringWithFormat:@"%d",i];
        ParkingLot *pl = [_plm fetchParkingLotWithId: myid];
        
        NSLog(@"%@", pl.name);
        [dataString appendString:[NSString stringWithFormat:@"%@\n",pl.name]];
    }
    
    [_myLabel setText:dataString];
    */
    // ParkingLot *lot = [[ParkingLot alloc] initWithId:@"2"];
    // [self.parkingLots addObject:lot];
    // [self fetchParkingLots];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSelect:(id)sender {
    
    [self performSegueWithIdentifier:@"showParkingLots" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIButton *button = sender;
    NSString *userType = nil;
    
    if([button isEqual:self.studentButton]) {
        
        NSLog(@"student segue");
        userType = @"STUDENT";
        
    } else if ([button isEqual:self.facultyButton]) {
        
        NSLog(@"faculty segue");
        userType = @"FACULTY";
        
    } else if ([button isEqual:self.handicapButton]) {
        
        NSLog(@"handicap segue");
        userType = @"HANDICAP";
        
    } else if ([button isEqual:self.visitorButton]) {
        
        NSLog(@"visitor segue");
        userType = @"VISITOR";
        
    }
    
    if ([[segue identifier] isEqualToString:@"showParkingLots"]) {
        
        ParkingLotViewController *plvc = [segue destinationViewController];
        plvc.userType = userType;
    }
    
    
}
@end
