//
//  LoaLoaController.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@class UserSequence;

@interface LoaLoaViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UILabel *userMessage;

@property (nonatomic, retain) UserSequence *mySequence;
@property (nonatomic, retain) NSString *state;


@property (weak, nonatomic) IBOutlet UIImageView *imageOverlayView;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;

- (void)initCapture;
- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender;

@end
