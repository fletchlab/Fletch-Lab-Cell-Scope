//
//  PictureInstructionsViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureInstructionsViewController.h"
#import "PictureInstructionSequence.h"

@implementation PictureInstructionsViewController

@synthesize delegate;
@synthesize instructionPicture;
@synthesize instructionSequence;

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
    NSString* currentImage = [self.instructionSequence currentImage];
    self.instructionPicture.image = [UIImage imageNamed:currentImage];
}

- (void)viewDidUnload
{
    [self setInstructionPicture:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)updateView
{
    // If we came from an intermediate state, advance sequence
    //if ([self.instructionSequence returnToCapture]) {
    //    [self.instructionSequence advanceSequence];
    //}
    /*
    NSString* currentImage = [self.instructionSequence currentImage];
    NSString* currentLabel = [self.instructionSequence currentMessage];
    self.instructionPicture.image = [UIImage imageNamed:currentImage];
    self.instructionLabel.text = currentLabel;
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onNext:(id)sender {
    [self.instructionSequence advanceSequence];
    if ([self.instructionSequence state] == @"ReturnToCapture") {
        [self.instructionSequence advanceSequence];
        [self.delegate pictureInstructionsSequenceComplete:self];
    }
    else {
        NSString* currentImage = [self.instructionSequence currentImage];
        self.instructionPicture.image = [UIImage imageNamed:currentImage];
    }
}

@end
