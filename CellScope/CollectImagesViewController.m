//
//  CollectImagesViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollectImagesViewController.h"
#import "CameraViewController.h"
#import "MicroscopeCamera.h"

@implementation CollectImagesViewController

@synthesize cameraView;
@synthesize cameraViewController;
@synthesize microscopeCamera;
@synthesize delegate;

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
    self.cameraViewController = [[CameraViewController alloc] initWithCamera:self.microscopeCamera andCameraLayer:self.cameraView];
    [self.cameraViewController startCapture];
}

- (void)viewDidUnload
{
    [self setCameraView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)snapPicture:(id)sender {
    NSLog(@"Hello snap");
    if(self.cameraViewController) 
    {
        NSLog(@"Send Flash");
        [self.cameraViewController cameraFlashAnimation];
    }
}

@end
