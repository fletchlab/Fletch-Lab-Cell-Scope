//
//  MicroscopeCameraViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MicroscopeCameraViewController.h"
#import "MicroscopeCamera.h"

@interface MicroscopeCameraViewController ()

@end

@implementation MicroscopeCameraViewController

@synthesize microscopeCamera;
@synthesize cameraPreviewView;
@synthesize screenOverlayView;

- (id)initWithCamera: (MicroscopeCamera*)camera andView:(UIView *)previewView
{
    self = [super init];
    self.microscopeCamera = camera;
    self.cameraPreviewView = previewView;
    self.screenOverlayView = [[UIView alloc] init];
    self.screenOverlayView.alpha = 0;
    [self.cameraPreviewView addSubview:screenOverlayView];
    return self;
}

- (void)initCapture
{
    // Create processing queue
    // Uncomment to create a live processing queue for video frames
    /*
    dispatch_queue_t queue;
    queue = dispatch_queue_create("CameraQueue", NULL);
    [microscopeCamera.captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // Set the buffer queue to our newly created queue
    [microscopeCamera.captureOutput setSampleBufferDelegate:self queue:queue];
    */
    
    /* Setup the preview layer */
    CALayer* prevLayer = [microscopeCamera generateVideoPreviewLayer];
    prevLayer.frame = self.cameraPreviewView.bounds;
	[self.cameraPreviewView.layer addSublayer:prevLayer];
    
    /* Start the capture */
    [self.microscopeCamera startCapture];
}

- (void)cameraFlashAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.screenOverlayView.alpha = 0.8;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.screenOverlayView.alpha = 0.0;
    }];
}

@end
