//
//  PictureInstructionsViewController.h
//  CellScope
//
//  Created by Matthew Bakalar on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureInstructionsViewController;
@class PictureInstructionSequence;

@protocol PictureInstructionsViewControllerDelegate <NSObject>
- (void)pictureInstructionsSequenceComplete:(PictureInstructionsViewController *)controller;
@end

@interface PictureInstructionsViewController : UIViewController

@property (weak, nonatomic) id <PictureInstructionsViewControllerDelegate> delegate;

@property (nonatomic, retain) PictureInstructionSequence* instructionSequence;
@property (weak, nonatomic) IBOutlet UIImageView *instructionPicture;
- (IBAction)onNext:(id)sender;


@end
