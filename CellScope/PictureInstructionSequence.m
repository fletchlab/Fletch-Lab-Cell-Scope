//
//  PictureInstructionSequence.m
//  CellScope
//
//  Created by Matthew Bakalar on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureInstructionSequence.h"

@implementation PictureInstructionSequence {
    NSInteger sequenceIdx;
}

@synthesize sequence;
@synthesize states;
@synthesize images;

- (id)init
{
    self = [super init];
    if(self) {
        sequenceIdx = 0;
        
        self.states = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"Extract Blood", @"PrepareSampleA",
                       @"Fill Capillary", @"PrepareSampleB",
                       @"Load Sample", @"LoadSampleA",
                       @"Load Sample", @"LoadSampleB",
                       @"Position Sample", @"PositionSample",
                       @"Prepare to Focus", @"FocusSample",
                       @"", @"ReturnToCapture",
                       @"Reposition Sample", @"RepositionSample",
                       @"Done", @"Done",
                       nil];
        
        self.images = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"patient_step_A.png", @"PrepareSampleA",
                       @"patient_step_B.png", @"PrepareSampleB",
                       @"sample_prep_A.png", @"LoadSampleA",
                       @"sample_prep_B.png", @"LoadSampleB",
                       @"sample_prep_C.png", @"PositionSample",
                       @"Focus_A.png", @"FocusSample",
                       @"move_Slide_A.png", @"RepositionSample",
                       @"Done", @"Done",
                       nil];
        
        self.sequence = [NSArray arrayWithObjects: @"PrepareSampleA", @"PrepareSampleB", @"LoadSampleA", @"LoadSampleB", @"PositionSample", @"ReturnToCapture", @"FocusSample", @"ReturnToCapture", @"RepositionSample", @"ReturnToCapture", @"FocusSample", @"ReturnToCapture", @"RepositionSample", @"ReturnToCapture", @"FocusSample", @"ReturnToCapture", nil];
    }
    return self;
}

- (NSString*)state
{
    return [self.sequence objectAtIndex:sequenceIdx];
}

- (NSString*)currentMessage
{
    NSString *state = [self.sequence objectAtIndex:sequenceIdx];
    NSString *message = [self.states objectForKey:state];
    return message;
}

- (NSString*)currentImage
{
    NSString *state = [self.sequence objectAtIndex:sequenceIdx];
    NSString *image = [self.images objectForKey:state];
    return image;
}

- (BOOL)atFirstState
{
    return sequenceIdx == 0;
}

- (BOOL)returnToCapture
{
    return [self.sequence objectAtIndex:sequenceIdx] == @"ReturnToCapture";
}

- (void)advanceSequence
{
    NSLog(@"Advance Picture Sequence");
    sequenceIdx += 1;
}



@end
