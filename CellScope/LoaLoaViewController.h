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
@class LoaLoaViewController;

@protocol LoaLoaViewControllerDelegate <NSObject>
- (void)loaLoaViewDidCancel:(LoaLoaViewController *)controller;
- (void)loaLoaViewSequenceComplete:(LoaLoaViewController *)controller;
@end

@interface LoaLoaViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <LoaLoaViewControllerDelegate> delegate;

/*!
 @brief Cell phone camera device, for use as the microscope camera.
 */
@property (nonatomic, retain) MicroscopeCamera* microscopeCamera;

/*!
 @brief Instructions to the user
 */
@property (weak, nonatomic) IBOutlet UILabel *userMessage;

- (IBAction)didCancel:(id)sender;

/*!
 @brief Instruction sequence. Contains messages to be displayed to user
 */
@property (nonatomic, retain) UserSequence *mySequence;

/*!
 @brief The current state of the instruction sequence
 */
@property (nonatomic, retain) NSString *state;

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageOverlayView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) CALayer *customLayer;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

- (void)initCapture;
- (void)tapGestureAction:(UITapGestureRecognizer *)sender;

@end
