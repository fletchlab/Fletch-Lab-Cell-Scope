//
//  CameraLayer.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "MicroscopeCamera.h"

@implementation CameraViewController

@synthesize cameraLayer;
@synthesize microscopeCamera;
@synthesize flashLayer;

- (id)initWithCamera: (MicroscopeCamera*)camera andCameraLayer: (UIView*) layer
{
    self = [super init];
    self.microscopeCamera = camera;
    self.cameraLayer = layer;
    return self;
}

- (void)startCapture
{
    NSLog(@"%@", self.microscopeCamera);
    /* Setup the preview layer */
    CALayer* prevLayer = [self.microscopeCamera generateVideoPreviewLayer];
    prevLayer.frame = self.cameraLayer.bounds;
	[self.cameraLayer.layer addSublayer:prevLayer];
    
    /* Setup the flash layer */
    self.flashLayer = [[UIView alloc] initWithFrame:self.cameraLayer.layer.frame];
    self.flashLayer.alpha = 0;
    self.flashLayer.backgroundColor = [UIColor whiteColor];
    [self.cameraLayer addSubview:self.flashLayer];
    
    /* Start the capture */
    [self.microscopeCamera startCapture];
}

- (void)cameraFlashAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.flashLayer.alpha = 0.8;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.flashLayer.alpha = 0.0;
    }];
}


@end
