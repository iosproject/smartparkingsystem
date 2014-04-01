//
//  MapViewController.h
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 4/1/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//  comment

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

// temporary properties
@property (strong, nonatomic) IBOutlet UILabel *lotLabel;
@property (strong, nonatomic) IBOutlet UITextView *lotData;

// string types
@property (strong, nonatomic) NSString *lotId;
@property (strong, nonatomic) NSString *lotName;
@property (strong, nonatomic) NSString *userType;

// parking spot array
@property (strong, nonatomic) NSArray *parkingSpots;

@end
