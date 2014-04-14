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

- (void) setUpScrollView {
    
    UIImage *lotImage = nil;
    
    if ([self.lotName isEqualToString:@"Kean Hall"]) {
        lotImage = [self imageByDrawingSpotsOnImage:[UIImage imageNamed:@"KeanF-01.png"]];
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
    
    self.scrollView.contentSize = lotImage.size;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    
    // add rounded corners
    self.scrollView.layer.cornerRadius = 18;
    self.scrollView.layer.masksToBounds = YES;
    
    // add gesture recognizers
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    // set the minimum zoom scale
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // max zoom scale
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // center
    [self centerScrollViewContents];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    // getthe point
    CGPoint pointInView = [recognizer locationInView:self.lotImageView];
    
    // set the zoom scale
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // rect to zoom
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // go to the point of interest
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.lotImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.lotImageView.frame = contentsFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.lotImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (int)getAvailableParkingsCount
{
    int count = 0;
    NSDictionary *spot = nil;
    NSString *isAvailable = nil;
    
    for (int i = 0; i < [self.parkingSpots count]; i++) {
        
        // grab a spot from the array
        spot = [self.parkingSpots objectAtIndex:i];
        
        // get the lot's name
        isAvailable = [spot objectForKey:@"available"];
        
        if([isAvailable isEqualToString:@"1"])
        {
            count++;
        }
    }
    
    return count;
}

- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    self.parkingSpots = [json objectForKey:@"parking_spots"];
    
    // NSLog(@"fetched %@ parking spots", [NSString stringWithFormat:@"%d",[self.parkingSpots count]]);
    [self setUpScrollView];
    [self.footerLabel setText:[NSString stringWithFormat:@"Available Parkings: %d",[self getAvailableParkingsCount]]];
    
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
    // 1384, 1385
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kean.skyfz.com/parking/parking_spot_json.php?parking_lot_id=%@&type=%@", self.lotId, self.userType]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

- (UIImage *)imageByDrawingSpotsOnImage:(UIImage *)image
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	// set the RGBA color
    CGContextSetRGBFillColor(ctx, 0, 255, 0, 1.0);
    
    // Draw a circle (filled) (x, y, w, h)
    CGContextFillEllipseInRect(ctx, CGRectMake(1277, 1961, 20.0, 20.0));
    
	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}

@end
