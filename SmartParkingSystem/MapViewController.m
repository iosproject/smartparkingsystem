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
    [self.headerLabel setText:[self.lotName uppercaseString]];
    
    
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
        lotImage = [self imageByDrawingSpotsOnImage:[UIImage imageNamed:@"HenningF-01.png"]];
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
    [self setUpScrollView];
    [self.footerLabel setText:[NSString stringWithFormat:@"Available Parkings: %d",[self getAvailableParkingsCount]]];
}

- (void) fetchParkingSpots {
    // 1384, 1385
    dispatch_async(kspQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kean.skyfz.com/parking/parking_spot_json.php?parking_lot_id=%@&type=%@", self.lotId, self.userType]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

// this function takes in an image to draw on and then returns it
- (UIImage *)imageByDrawingSpotsOnImage:(UIImage *)image
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSDictionary *spot = nil;
    NSString *isAvailable = nil;
    int spot_id = 0;
    
    // loop through the parking spots
    for (int i = 0; i < [self.parkingSpots count]; i++) {
        
        // grab a spot from the array
        spot = [self.parkingSpots objectAtIndex:i];
        
        // get the spots availability
        isAvailable = [spot objectForKey:@"available"];
        
        // get the id
        spot_id = [[spot objectForKey:@"id"] intValue];
       
        if([isAvailable isEqualToString:@"1"] && spot_id >= 572 && spot_id <= 576)
        {
            
            // set the RGBA color to green
            CGContextSetRGBFillColor(ctx, 0, 255, 0, 1.0);
            
            int x = [[spot objectForKey:@"position_x"] intValue];
            int y = [[spot objectForKey:@"position_y"] intValue];
            
            // Draw a circle (filled) (x, y, w, h)
            CGContextFillEllipseInRect(ctx, CGRectMake(x, y, 20.0, 20.0));
            
        }
        else if ([isAvailable isEqualToString:@"0"] && spot_id >= 572 && spot_id <= 576)
        {
            // set the RGBA color to green
            CGContextSetRGBFillColor(ctx, 255, 0, 0, 1.0);
            
            int x = [[spot objectForKey:@"position_x"] intValue];
            int y = [[spot objectForKey:@"position_y"] intValue];
            
            // Draw a circle (filled) (x, y, w, h)
            CGContextFillEllipseInRect(ctx, CGRectMake(x, y, 20.0, 20.0));
        }
    }
    
	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}

@end
