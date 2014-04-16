//
//  ParkingLotViewController.h
//  SmartParkingSystem
//
//  Created by Joshua Lisojo on 4/1/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingLotViewController : UIViewController

@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
