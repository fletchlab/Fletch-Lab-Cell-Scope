//
//  MicroscopeCamera.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MicroscopeCamera.h"

NSString * const NOTIF_VideoProgress = @"VideoProgress"; // Notification ID for monitoring video progress

@implementation MicroscopeCamera

@synthesize captureInput;
@synthesize captureOutput;
@synthesize captureSession;
@synthesize taskTimer;

- (id)init 
{
    // Setup input and output devices
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    
    // Lock the focus
    BOOL focusSupported = [captureInput.device isFocusModeSupported:AVCaptureFocusModeLocked] & 
        [captureInput.device lockForConfiguration:nil];
    
    if (focusSupported) {
        [captureInput.device setFocusMode:AVCaptureFocusModeLocked];
        [captureInput.device unlockForConfiguration];
    }

    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // Process frames while dispatch queue is occupied?
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // Set the pixel type for the captured video
    NSString* key = (NSString*) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [self.captureOutput setVideoSettings:videoSettings];
    
    // Create the capture session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // Add input and output to the session
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];

    // Set capture quality
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    return self;
}

- (void)recordVideoForTime: (NSNumber*)recordTime
{
    // Setup a task timer
    taskTimeElapsed = 0.0;
    taskTimerPeriod = 0.05;
    taskTime = recordTime.floatValue;
    
    // Execute the function onTaskTimer every taskTimerPeriod seconds
    self.taskTimer = [NSTimer scheduledTimerWithTimeInterval:taskTimerPeriod target:self selector:@selector(onTaskTimer:) userInfo:nil repeats:YES];
}

- (void)onTaskTimer:(NSTimer *)timer {
    // Recalculate elapsed time
    taskTimeElapsed += taskTimerPeriod;
    NSNumber* progress = [NSNumber numberWithFloat:(taskTimeElapsed / taskTime)];
    
    // Setup dictionary to pass current progress to any observers
    NSDictionary *data = [[NSDictionary alloc]
                          initWithObjectsAndKeys: progress, @"progress", nil];
    
    // Notify observers of current recording progress
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NOTIF_VideoProgress object:nil userInfo:data];
    
    // If task is complete, stop and clear the timer
    if (taskTimeElapsed >= taskTime) {
        [self.taskTimer invalidate];
        self.taskTimer = nil;
    }
}

- (void)startCapture
{
    // Start the capture
    [self.captureSession startRunning];
}

- (AVCaptureVideoPreviewLayer*)generateVideoPreviewLayer
{
    // Setup the preview layer
    AVCaptureVideoPreviewLayer* prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return prevLayer;
}

@end
