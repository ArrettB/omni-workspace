//
//  ViewController.m
//  SignatureCatpure
//
//  Created by Chad Brandt on 9/20/12.
//  Copyright (c) 2012 KettleRiver. All rights reserved.
//

#import "MainViewController.h"
#import "T1Autograph.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController (){
    UIView *autographView;
}
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation MainViewController
@synthesize webview = _webview;
@synthesize autograph = _autograph;
@synthesize outputImage = _outputImage;
@synthesize autographModal = _autographModal;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *urlAddress = @"http://www.google.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webview loadRequest:requestObj];
    
    // Make a view for the signature
	autographView = [[UIView alloc] initWithFrame:CGRectMake(18, 375, 280, 80)];
	autographView.layer.borderColor = [UIColor blackColor].CGColor;
	autographView.layer.borderWidth = 3;
	autographView.layer.cornerRadius = 10;
	[autographView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:autographView];
	
	// Initialize Autograph library
	self.autograph = [T1Autograph autographWithView:autographView delegate:self];
	
	// to remove the watermark, get a license code from Ten One, and enter it here
	[self.autograph setLicenseCode:@"4fabb271f7d93f07346bd02cec7a1ebe10ab7bec"];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma autograph delegates
-(void)didDismissModalView {
	NSLog(@"Autograph modal signature has been cancelled");
}

-(void)autographDidCompleteWithNoData {
	NSLog(@"User pressed the done button without signing");
}

-(void)autograph:(T1Autograph *)autograph didCompleteWithSignature:(T1Signature *)signature {
	
	// Log information about the signature
	NSLog(@"-- Autograph signature completed. --");
	NSLog(@"Hash value: %@",signature.hashString);
	NSLog(@"Frame: %@",NSStringFromCGRect(signature.frame));	// can be used to place a signature image directly over original signature
	
	// display the signature
	[self.outputImage removeFromSuperview];
	self.outputImage = [signature imageView];
	[self.outputImage setFrame:CGRectMake(18, 375, 280, 80)];
	[self.view addSubview:self.outputImage];
    
    
    [autographView removeFromSuperview];
	
	// you can access the raw image data like this:
	// UIImage *img = [UIImage imageWithData:signature.imageData];
	
	// you can access the raw data points like this:
	// NSArray *rawPoints = signature.rawPoints;
	
	// If the modal view was used, release it.  You won't need to do this if you're not using the modal.
	if (self.autographModal!=nil) {
		self.autographModal = nil;
	}
	
}

#pragma selectors
-(IBAction)doneButtonAction:(id)sender {
	[self.autograph done:self];
	
}
- (IBAction)reset:(id)sender {
    [self.autograph reset:self];
    [self.view addSubview:autographView];
    [self.outputImage removeFromSuperview];
   
}


#pragma private methods
- (void)uploadImage:(UIImage*) image {
	/*
	 turning the image into a NSData object
	 setting the quality to 90
     */
	NSData *imageData = UIImageJPEGRepresentation(image, 90);
    
	NSString *urlString = @"http://krc.mn/";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition:form-data; name=\"userfile\"; filename=\"signature.jpg\"rn" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-streamrnrn" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"rn--%@--rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@",returnString);
}

@end
