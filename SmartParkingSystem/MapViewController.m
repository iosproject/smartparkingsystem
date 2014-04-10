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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *lotImageView;
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
    [self.headerLabel setText:self.lotName];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
    // 4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // 6
    [self centerScrollViewContents];
     */
}

- (void)centerScrollViewContents
{
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGSize contentSize = self.lotImageView.frame.size;
    CGPoint contentOffset;
    
    if (contentSize.width < scrollViewSize.width)
    {
        contentOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0;
    }
    
    if (contentSize.height < scrollViewSize.height)
    {
        contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0;
    }
    
    [self.scrollView setContentOffset:contentOffset];
}

- (void) setUpScrollView {
    
    UIImage *lotImage = nil;
    
    if ([self.lotName isEqualToString:@"Kean Hall"]) {
        lotImage = [UIImage imageNamed:@"KeanF-01.png"];
    }
    else if([self.lotName isEqualToString:@"Bruce"]) {
        lotImage = [UIImage imageNamed:@"BruceF-01.png"];
    }
    else if([self.lotName isEqualToString:@"Hennings Hall"]) {
        lotImage = [UIImage imageNamed:@"HenningF-01.png"];
    }
    else if([self.lotName isEqualToString:@"STEM"]) {
        lotImage = [UIImage imageNamed:@"STEMF-01.png"];
    }
    else if([self.lotName isEqualToString:@"Vaughn Eames"]) {
        lotImage = [UIImage imageNamed:@"VEF-01.png"];
    }

    self.lotImageView = [[UIImageView alloc] initWithImage:lotImage];
    [self.scrollView addSubview:self.lotImageView];
    self.scrollView.contentSize = self.lotImageView.bounds.size;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    self.scrollView.minimumZoomScale = 0.10;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.zoomScale = 0.1;
    
    [self centerScrollViewContents];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.lotImageView;
}

- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    self.parkingSpots = [json objectForKey:@"parking_spots"];
    
    NSLog(@"fetched %@ parking spots", [NSString stringWithFormat:@"%d",[self.parkingSpots count]]);
    [self setUpScrollView];
    [self.footerLabel setText:[NSString stringWithFormat:@"Available Parkings: %d",[self.parkingSpots count]]];
    
    // NSMutableString *dataString = [[NSMutableString alloc] init];
    // [dataString appendString:[NSString stringWithFormat:@"%@ has %d spots available of type %@", self.lotName, [self.parkingSpots count], self.userType]];
    /*
    
    NSDictionary *lot = nil;
    NSString *lot_name = nil;
    for (int i = 0; i < [self.parkingLots count]; i++) {
        
        // grab a spot from the array
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
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kean.skyfz.com/parking/parking_spot_json.php?parking_lot_id=%@&type=%@", self.lotId, self.userType]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}



@end
