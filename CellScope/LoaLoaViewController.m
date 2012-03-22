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

@synthesize cameraPreviewView;
@synthesize userMessage;
@synthesize mySequence;
@synthesize state;
@synthesize imageOverlayView;

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
    [self setCameraPreviewView:nil];
    [self setImageOverlayView:nil];
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
    self.prevLayer.frame = self.cameraPreviewView.bounds;
	self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.cameraPreviewView.layer addSublayer:self.prevLayer];
    
    /* Setup the overlay layer */
    self.imageOverlayView.alpha = 0;
    
    /* Start the capture */
    NSLog(@"Starting Image Capture");
    [self.captureSession startRunning];
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
    self.userMessage.text = [self.mySequence nextMessage];
    [UIView animateWithDuration:0.1 animations:^{
        self.imageOverlayView.alpha = 0.8;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.imageOverlayView.alpha = 0.0;
    }];
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
    
	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

@end
