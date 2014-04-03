//
//  ViewController.h
//  SmartParkingSystem
//
//  Created by Computer Science on 3/24/14.
//  Copyright (c) 2014 Computer Science. All rights reserved.
//
// initial comment

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *myLabel;

// view buttons
@property (strong, nonatomic) IBOutlet UIButton *studentButton;
@property (strong, nonatomic) IBOutlet UIButton *facultyButton;
@property (strong, nonatomic) IBOutlet UIButton *handicapButton;
@property (strong, nonatomic) IBOutlet UIButton *visitorButton;

// button action
- (IBAction)onSelect:(id)sender;

@end
