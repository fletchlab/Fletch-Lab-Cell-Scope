//
//  MicroscopeCamera.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MicroscopeCamera.h"

@implementation MicroscopeCamera

@synthesize captureInput;
@synthesize captureOutput;
@synthesize captureSession;

- (id)init 
{
    /* Setup input and output devices */
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /* Process frames while dispatch queue is occupied? */
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    /* Set the pixel type for the captured video */
    NSString* key = (NSString*) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [self.captureOutput setVideoSettings:videoSettings];
    
    /* Create the capture session */
    self.captureSession = [[AVCaptureSession alloc] init];
    
    /* Add input and output to the session */
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    /* Set capture quality */
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    return self;
}

- (void)startCapture
{
    /* Start the capture */
    [self.captureSession startRunning];
}

- (AVCaptureVideoPreviewLayer*)generateVideoPreviewLayer
{
    /* Setup the preview layer */
    AVCaptureVideoPreviewLayer* prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return prevLayer;
}

@end
