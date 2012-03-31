//
//  MicroscopeCameraViewController.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MicroscopeCamera;

@interface MicroscopeCameraViewController : NSObject

@property (weak, nonatomic) MicroscopeCamera* microscopeCamera;
@property (weak, nonatomic) UIView *cameraPreviewView;
@property (weak, nonatomic) UIView *screenOverlayView;

- (id)initWithCamera: (MicroscopeCamera*) camera andView: (UIView*) previewView;
- (void)initCapture;

@end
