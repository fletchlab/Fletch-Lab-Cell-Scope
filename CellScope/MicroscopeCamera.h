//
//  MicroscopeCamera.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface MicroscopeCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    float taskTime;
    float taskTimeElapsed;
    float taskTimerPeriod;
    BOOL recording;
    int frameNumber;
}

extern NSString * const NOTIF_VideoProgress;

/*!
 @brief	The AVFoundation input device for this camera
 */
@property (nonatomic, retain) AVCaptureDeviceInput *captureInput;

/*!
 @brief	An AVFoundation data output for accessing device data
 */
@property (nonatomic, retain) AVCaptureVideoDataOutput *captureOutput;

/*!
 @brief An AVFoundation capture session for using this camera
 */
@property (nonatomic, retain) AVCaptureSession *captureSession;

/*!
 @brief Video progress timer
 */
@property (nonatomic, retain) NSTimer *taskTimer;

@property (nonatomic, retain) AVAssetWriter *assetWriter;

@property (nonatomic, retain) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor ;

@property (nonatomic, retain) AVAssetWriterInput *assetWriterInput;

@property (nonatomic, retain) NSURL *outputURL;

- (void)startCapture;

/*!
 @brief Record a video for a preset amount of time. Placeholder functionality
 */
- (void)recordVideoForTime: (NSNumber*)recordTime;

/*!
 @brief Create the AVFoundation preview layer for viewing output from the camera
 */
- (AVCaptureVideoPreviewLayer*)generateVideoPreviewLayer;
- (void) initVideo;
- (void) finishVideo;

@end
