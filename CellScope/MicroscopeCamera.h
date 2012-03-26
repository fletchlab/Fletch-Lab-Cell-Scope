//
//  MicroscopeCamera.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface MicroscopeCamera : NSObject

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

- (void)startCapture;

- (AVCaptureVideoPreviewLayer*)generateVideoPreviewLayer;

@end
