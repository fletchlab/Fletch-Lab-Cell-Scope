//
//  LoaLoaController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoaLoaViewController.h"
#import "UserSequence.h"

@implementation LoaLoaViewController

@synthesize captureSession;
@synthesize imageView;
@synthesize customLayer;
@synthesize prevLayer;

@synthesize userMessage;
@synthesize cameraPreviewView;
@synthesize mySequence;
@synthesize state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        NSLog(@"Initializing the view LoaLoaViewController");
        self.mySequence = [[UserSequence alloc] init];
        self.state = [self.mySequence nextMessage];
        [self.userMessage setText: self.state];
        NSLog(@"State: %@", self.state);
        [self initCapture];
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setUserMessage:nil];
    [self setCameraPreviewView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initCapture
{
    /* Setup input and output devices */
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /* Process frames while dispatch queue is occupied? */
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    /* Create processing queue */
    dispatch_queue_t queue;
    queue = dispatch_queue_create("CameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    /* Set the buffer queue to our newly created queue */
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    /* Set the pixel type for the captured video */
    NSString* key = (NSString*) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    /* Create the capture session */
    self.captureSession = [[AVCaptureSession alloc] init];
    
    /* Add input and output to the session */
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    /* Set capture quality */
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    /* Setup the preview layer */
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    CGRect layerRect = [self.cameraPreviewView.layer bounds];
	[self.prevLayer setBounds:layerRect];
	[self.prevLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
	self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.cameraPreviewView.layer addSublayer:self.prevLayer];
    
    /* Start the capture */
    NSLog(@"Starting Image Capture");
    [self.captureSession startRunning];
}

#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0); 
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer);  
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
	
    /*We release some components*/
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);
    
    /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (__bridge id) newImage waitUntilDone:YES];
	
	/*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	 Same thing as for the CALayer we are not in the main thread so ...*/
	UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
	
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
	
	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

@end
