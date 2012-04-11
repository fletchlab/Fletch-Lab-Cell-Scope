//
//  CollectImagesViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnalysisController.h"
#import "CollectImagesViewController.h"
#import "PictureInstructionsViewController.h"
#import "CameraViewController.h"
#import "MicroscopeCamera.h"
#import "DZRoundProgressView.h"
#import "UserSequence.h"
#import "PictureInstructionSequence.h"

@interface CollectImagesViewController (private)

- (void)videoProgressNotification:(NSNotification *)notif;

@end
@implementation CollectImagesViewController


@synthesize roundProgressView;
@synthesize videoProgressBar;
@synthesize cameraView;
@synthesize cameraViewController;
@synthesize microscopeCamera;
@synthesize userSequence;
@synthesize instructionSequence;
@synthesize delegate;
@synthesize userMessageLabel;
@synthesize userMessageImage;
@synthesize analyzingLabel;
@synthesize imageProcessingActivityIndicator;
@synthesize instructionMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.microscopeCamera = [[MicroscopeCamera alloc] init];
    self.userSequence = [[UserSequence alloc] init];
    self.instructionSequence = [[PictureInstructionSequence alloc] init];
    self.videoProgressBar.hidden = YES;
    self.imageProcessingActivityIndicator.hidden = YES;
    self.analyzingLabel.hidden = YES;
    self.cameraViewController = [[CameraViewController alloc] initWithCamera:self.microscopeCamera andCameraLayer:self.cameraView];
    if (self.instructionMode == @"PictureInstructions")  {
        [self.userSequence usePictureInstructionStates];
    }
    if (![self.userSequence atFirstState]) {
        self.userMessageLabel.text = [self.userSequence currentMessage];
    }
    [self.cameraViewController startCapture];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString* state = [self.userSequence state];
    if(state == @"PictureInstruction")
    {
        [self enterPictureInstructionView];
    }
    else if (state == @"Done")
    {
        [self performSegueWithIdentifier: @"Results" 
                                  sender: self];
    }
    else if (state == @"Return")
    {
        [self.delegate collectImagesViewSequenceComplete:self];
    }
    else {
        [UIView animateWithDuration:1.0 animations:^{
            self.userMessageLabel.alpha = 0.0;
        }];
        self.userMessageLabel.text = [self.userSequence currentMessage];
        [UIView animateWithDuration:1.0 animations:^{
            self.userMessageLabel.alpha = 1.0;
        }];
    }
}

- (void)enterPictureInstructionView
{
    [self performSegueWithIdentifier: @"GraphicInstruction" 
                              sender: self];
}

- (void)viewDidUnload
{
    [self setCameraView:nil];
    [self setVideoProgressBar:nil];
    [self setUserMessageLabel:nil];
    [self setImageProcessingActivityIndicator:nil];
    [self setAnalyzingLabel:nil];
    [self setRoundProgressView:nil];
    [self setUserMessageImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)snapPicture {
    if(self.cameraViewController) 
    {
        [self.cameraViewController cameraFlashAnimation];
    }
}

- (IBAction)onActionButtonTouch:(id)sender {
    
    if(([self.userSequence state] == @"CollectImage") || ([self.userSequence state] == @"CollectImage2"))
    {
        [self recordVideoPresetTime];
    }
    else {
        [self.userSequence advanceSequence];
        [self viewDidAppear:YES];
    }
}

- (void)recordVideoPresetTime {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(videoProgressNotification:) 
                                                 name:NOTIF_VideoProgress object:nil]; 
    self.videoProgressBar.progress = 0.0;
    self.videoProgressBar.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        self.userMessageLabel.alpha = 0;
        self.userMessageImage.alpha = 0;
    }];
    [self.microscopeCamera recordVideoForTime:[NSNumber numberWithInt:5.0]];
}

- (void)startImageProcessingDummy
{
    float processingTime = 2.5; // Pretend to process image for 2.5 second
    [self.imageProcessingActivityIndicator startAnimating]; 
    self.analyzingLabel.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:processingTime target:self selector:@selector(onDoneProcessing:) userInfo:nil repeats:NO];
    [microscopeCamera analyzeImages];
}

- (void)onDoneProcessing:(NSTimer *)timer
{
    [self.imageProcessingActivityIndicator stopAnimating];
    self.analyzingLabel.hidden = YES;
    [self.userSequence advanceSequence];
    [self viewDidAppear:YES];
}

- (void)videoProgressNotification:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;
    NSNumber *progress = (NSNumber*)[userInfo objectForKey:@"progress"];
    self.videoProgressBar.progress = progress.floatValue;
    self.roundProgressView.progress = progress.floatValue;
    if (progress.floatValue >= 1.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.cameraViewController cameraFlashAnimation];
        self.roundProgressView.progress = 0.0;
        self.videoProgressBar.hidden = YES;
        [self startImageProcessingDummy];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GraphicInstruction"])
	{
		PictureInstructionsViewController *pictureInstructionsViewController = segue.destinationViewController;
        pictureInstructionsViewController.delegate = self;
        pictureInstructionsViewController.instructionSequence = self.instructionSequence;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.userMessageLabel.alpha = 0;
            self.userMessageImage.alpha = 0;
        }];
	}
    else if([segue.identifier isEqualToString:@"Results"])
	{
		ResultsViewController *resultsViewController = segue.destinationViewController;
        resultsViewController.delegate = self;
	}

}

#pragma mark - Graphic Instructions Delegate

- (void)pictureInstructionsSequenceComplete:(PictureInstructionsViewController *)controller
{
    [self.userSequence advanceSequence];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resultsViewControllerDone:(ResultsViewController *)controller
{
    [self.userSequence advanceSequence];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
