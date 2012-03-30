//
//  LoaLoaController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoaLoaViewController.h"
#import "UserSequence.h"
#import "Microscopecamera.h"

@implementation LoaLoaViewController

@synthesize imageView;
@synthesize customLayer;

@synthesize microscopeCamera;
@synthesize userMessage;
@synthesize mySequence;
@synthesize state;
@synthesize cameraPreviewView;
@synthesize cancelButton;
@synthesize imageOverlayView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        self.microscopeCamera = [[MicroscopeCamera alloc] init];
        self.mySequence = [[UserSequence alloc] init];
        self.state = [self.mySequence nextMessage];
        [self.userMessage setText: self.state];
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
    [self setCameraPreviewView:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        [gestureRecognizer addTarget:self action:@selector(tapGestureAction:)];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)initCapture
{
    /* Create processing queue */
    dispatch_queue_t queue;
    queue = dispatch_queue_create("CameraQueue", NULL);
    [microscopeCamera.captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    /* Set the buffer queue to our newly created queue */
    [microscopeCamera.captureOutput setSampleBufferDelegate:self queue:queue];
    
    /* Setup the preview layer */
    CALayer* prevLayer = [microscopeCamera generateVideoPreviewLayer];
    prevLayer.frame = self.cameraPreviewView.bounds;
	[self.cameraPreviewView.layer addSublayer:prevLayer];
    
    /* Setup the overlay layer */
    self.imageOverlayView.alpha = 0;
    
    /* Start the capture */
    [self.microscopeCamera startCapture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
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

- (IBAction)didCancel:(id)sender {
    [self.delegate loaLoaViewDidCancel:self];
}

@end
