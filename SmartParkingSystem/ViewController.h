//
//  ViewController.h
//  SmartParkingSystem
//
//  Created by Computer Science on 3/24/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//
// initial comment

#import <UIKit/UIKit.h>
#import "ParkingLot.h"

@interface ViewController : UIViewController


@property NSMutableArray *parkingLots;
@property (strong, nonatomic) IBOutlet UITextView *myLabel;

@end
