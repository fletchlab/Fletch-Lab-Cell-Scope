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

@protocol CollectImagesViewControllerDelegate <NSObject>

- (void)collectImagesViewDidCancel:(CollectImagesViewController *)controller;
- (void)collectImagesViewSequenceComplete:(CollectImagesViewController *)controller;

@end

@interface CollectImagesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (weak, nonatomic) id <CollectImagesViewControllerDelegate> delegate;
@property (strong, nonatomic) MicroscopeCamera* microscopeCamera;
@property (strong, nonatomic) CameraViewController* cameraViewController;

- (IBAction)snapPicture:(id)sender;

@end
