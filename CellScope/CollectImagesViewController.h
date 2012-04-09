//
//  CollectImagesViewController.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@class MicroscopeCamera;
@class CollectImagesViewController;
@class UserSequence;
@class DZRoundProgressView;

@protocol CollectImagesViewControllerDelegate <NSObject>

- (void)collectImagesViewDidCancel:(CollectImagesViewController *)controller;
- (void)collectImagesViewSequenceComplete:(CollectImagesViewController *)controller;

@end

@interface CollectImagesViewController : UIViewController
@property (weak, nonatomic) IBOutlet DZRoundProgressView *roundProgressView;

@property (weak, nonatomic) IBOutlet UIProgressView *videoProgressBar;
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (weak, nonatomic) id <CollectImagesViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *userMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userMessageImage;
@property (weak, nonatomic) IBOutlet UILabel *analyzingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageProcessingActivityIndicator;
@property (strong, nonatomic) MicroscopeCamera* microscopeCamera;
@property (nonatomic, retain) UserSequence* userSequence;
@property (strong, nonatomic) CameraViewController* cameraViewController;

- (IBAction)snapPicture:(id)sender;
- (IBAction)recordVideoPresetTime:(id)sender;
- (void)startImageProcessingDummy;
- (void)nextUserMessage;
- (void)onDoneProcessing:(NSTimer *)timer;

@end
