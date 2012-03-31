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
@class MicroscopeCameraViewController;
@class CollectImagesViewController;
@class MicroscopeCamera;

@protocol CollectImagesViewControllerDelegate <NSObject>

- (void)collectImagesViewDidCancel:(CollectImagesViewController *)controller;
- (void)collectImagesViewSequenceComplete:(CollectImagesViewController *)controller;

@end

@interface CollectImagesViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <CollectImagesViewControllerDelegate> delegate;

@property (nonatomic, retain) MicroscopeCameraViewController* cameraViewController;

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UILabel *userMessage;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) MicroscopeCamera *microscopeCamera;
@property (nonatomic, retain) UserSequence *mySequence;
@property (nonatomic, retain) NSString *state;

- (IBAction)didCancel:(id)sender;
- (void)initMicroscopeCameraView;
- (void)tapGestureAction:(UITapGestureRecognizer *)sender;

@end
