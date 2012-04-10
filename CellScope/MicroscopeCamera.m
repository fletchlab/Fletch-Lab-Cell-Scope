//
//  MicroscopeCamera.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MicroscopeCamera.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString * const NOTIF_VideoProgress = @"VideoProgress"; // Notification ID for monitoring video progress

@implementation MicroscopeCamera

@synthesize captureInput;
@synthesize captureOutput;
@synthesize captureSession;
@synthesize taskTimer;
@synthesize assetWriter;
@synthesize pixelBufferAdaptor;
@synthesize assetWriterInput;
@synthesize outputURL;

- (id)init 
{
    // Setup input and output devices
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    //lock the focus
    if ([captureInput.device isFocusModeSupported:AVCaptureFocusModeLocked] && [captureInput.device lockForConfiguration:nil]) {
        [captureInput.device setFocusMode:AVCaptureFocusModeLocked];
        //hard to tell if the focus lock is actually working, but you can clearly that locking in general is working by setting an exposure lock and covering the sensor when you start a new scan
        //[captureInput.device setExposureMode:AVCaptureExposureModeLocked];
        [captureInput.device unlockForConfiguration];
         NSLog(@"locked focus");
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
    
    /* set the video output to 640x480 in H.264, via an asset writer */
    NSDictionary *outputSettings =
    [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithInt:640], AVVideoWidthKey,
    [NSNumber numberWithInt:480], AVVideoHeightKey,
    AVVideoCodecH264, AVVideoCodecKey,
    nil];
    
    //set up the assetwriter input
    assetWriterInput = [AVAssetWriterInput 
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:outputSettings];
    
    // set up the AVAssetWriterPixelBufferAdaptor to expect 32BGRA input
     pixelBufferAdaptor =
    [[AVAssetWriterInputPixelBufferAdaptor alloc] 
     initWithAssetWriterInput:assetWriterInput 
     sourcePixelBufferAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], 
      kCVPixelBufferPixelFormatTypeKey,
      nil]];
    
    //set out file url
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            NSLog(@"output error");
        }
    }
    /*set the input so that it tries to avoid being unavailable at inopportune moments as it is going in real time */
    assetWriterInput.expectsMediaDataInRealTime = YES;
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    return self;
}

- (void)recordVideoForTime: (NSNumber*)recordTime
{
    // Setup a task timer
    taskTimeElapsed = 0.0;
    taskTimerPeriod = 0.05;
    taskTime = recordTime.floatValue;
    if(recording==FALSE){
        //[self initVideo];
    }
    
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
        //[self finishVideo];
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

- (void) initVideo{
    NSLog(@"start recording");
    recording=TRUE;
    frameNumber=0;

    //delete files in temp folder
    NSFileManager* fileManager = [NSFileManager defaultManager];
    // get all files in the temp folder
    NSArray* files = [fileManager   contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    // delete
    for (int i=0; i<[files count]; i++)
    {
        NSString* fileName = [files objectAtIndex:i];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), fileName] error:nil];
    }
    
    //create assetwriter H.264 within the normal MPEG4 container 
    assetWriter = [[AVAssetWriter alloc]
                   initWithURL:outputURL
                   fileType:
                   AVFileTypeMPEG4
                   error:nil
                   ];
    [assetWriter addInput:assetWriterInput];
    
    
    [assetWriter startWriting];
    [assetWriter startSessionAtSourceTime:kCMTimeZero];

}
- (void) finishVideo{
    NSLog(@"stop recording");
    recording=FALSE;
    [assetWriter finishWriting];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                    completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if (error)
             {
                 
             }
         }];
    }
}

- (void)        captureOutput:(AVCaptureOutput *)captureOutput 
        didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
               fromConnection:(AVCaptureConnection *)connection
{
    if (recording==TRUE){
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //NSLog(@"in capture output");
    //add current imageBuffer to our pixelbufferadaptor
    //static int64_t frameNumber = 0;
    if(assetWriterInput.readyForMoreMediaData)
        //NSLog(@"adding imagebuffer %i",frameNumber);
        
        [pixelBufferAdaptor appendPixelBuffer:imageBuffer
                         withPresentationTime:CMTimeMake(frameNumber, 25)];
        
    frameNumber++;
    }
}


@end
