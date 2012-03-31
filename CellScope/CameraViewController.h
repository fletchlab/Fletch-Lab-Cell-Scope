//
//  CameraLayer.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class MicroscopeCamera;

@interface CameraViewController : NSObject

@property (nonatomic, weak) UIView* cameraLayer;
@property (nonatomic, strong) UIView* flashLayer;
@property (nonatomic, weak) MicroscopeCamera* microscopeCamera;

- (id)initWithCamera: (MicroscopeCamera*)camera andCameraLayer: (UIView*) layer;
- (void)startCapture;
- (void)cameraFlashAnimation;

@end
