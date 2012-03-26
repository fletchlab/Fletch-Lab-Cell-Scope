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
@class MicroscopeCamera;

@interface LoaLoaViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>

/*!
 @brief Cell phone camera device, for use as the microscope camera.
 */
@property (nonatomic, retain) MicroscopeCamera* microscopeCamera;

/*!
 @brief Instructions to the user
 */
@property (weak, nonatomic) IBOutlet UILabel *userMessage;

/*!
 @brief Instruction sequence. Contains messages to be displayed to user
 */
@property (nonatomic, retain) UserSequence *mySequence;

/*!
 @brief The current state of the instruction sequence
 */
@property (nonatomic, retain) NSString *state;

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIImageView *imageOverlayView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) CALayer *customLayer;

- (void)initCapture;
- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender;

@end
