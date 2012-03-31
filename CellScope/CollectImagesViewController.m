//
//  LoaLoaController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollectImagesViewController.h"
#import "UserSequence.h"
#import "MicroscopeCameraViewController.h"
#import "MicroscopeCamera.h"

@implementation CollectImagesViewController

@synthesize userMessage;
@synthesize mySequence;
@synthesize state;
@synthesize cancelButton;
@synthesize delegate;
@synthesize cameraViewController;
@synthesize cameraPreviewView;
@synthesize microscopeCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        // Initialize data
        self.mySequence = [[UserSequence alloc] init];
        self.microscopeCamera = [[MicroscopeCamera alloc] init];
        self.state = [self.mySequence nextMessage];
        [self.userMessage setText: self.state];
                
        // Initialize subviews
        self.cameraViewController = [[MicroscopeCameraViewController alloc] initWithCamera:microscopeCamera andView:self.cameraPreviewView];
        [self.cameraViewController initCapture];
    }
}

- (void)viewDidUnload
{
    [self setUserMessage:nil];
    [self setCancelButton:nil];
    [self setCameraPreviewView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        [gestureRecognizer addTarget:self action:@selector(tapGestureAction:)];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    self.userMessage.text = [self.mySequence nextMessage];
}

- (IBAction)didCancel:(id)sender {
    [self.delegate collectImagesViewDidCancel:self];
}

@end
