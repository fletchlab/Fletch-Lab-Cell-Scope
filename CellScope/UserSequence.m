//
//  UserSequence.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSequence.h"

@implementation UserSequence {
    NSInteger sequenceIdx;
    NSInteger used;
}

@synthesize sequence;
@synthesize states;

- (id)init
{
    self = [super init];
    if(self) {
        sequenceIdx = 0;
        used = -1;
        NSLog(@"Initializing the UserSequence");
        [self setDefaultStates];
    }
    return self;
}

- (void)setDefaultStates
{
    self.states = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Find initial field of view, then tap camera to record video", @"CollectImage",
                   @"Find new field of view, then tap camera to record video", @"CollectImage2", 
                   @"Done", @"Done",
                   @"", @"Return",
                   nil];
    self.sequence = [NSArray arrayWithObjects: @"CollectImage", @"CollectImage2", @"CollectImage2", @"CollectImage2", @"Done", @"Return", nil];

}

- (void)usePictureInstructionStates
{
    self.states = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Position the sample, then tap camera to continue", @"WaitForPositioning",
                   @"None", @"PictureInstruction",
                   @"Adjust the microscope focus, then tap camera to continue", @"WaitForFocusing",
                   @"Tap camera to record video", @"CollectImage",
                   @"Locate a new field of view", @"WaitForRepositioning",
                   @"Done", @"Done",
                   @"", @"Return",
                   nil];
    self.sequence = [NSArray arrayWithObjects: @"PictureInstruction", @"WaitForPositioning", @"PictureInstruction", @"WaitForFocusing", @"CollectImage", @"PictureInstruction", @"WaitForRepositioning", @"PictureInstruction", @"WaitForFocusing", @"CollectImage", @"PictureInstruction", @"WaitForRepositioning", @"PictureInstruction", @"WaitForFocusing", @"CollectImage", @"Done", @"Return", nil];
}

- (BOOL)atFirstState
{
    BOOL answer = (used == -1);
    used = 1;
    return answer;
}

- (NSString*)state
{
    return [self.sequence objectAtIndex:sequenceIdx];
}

- (NSString*)currentMessage
{
    NSString *state = [self.sequence objectAtIndex:sequenceIdx];
    NSString *message = [self.states objectForKey:state];
    NSLog(@"State: %@ Message: %@", state, message);
    return message;
}

- (void)advanceSequence
{
    NSString *state = [self.sequence objectAtIndex:sequenceIdx];
    NSString *nextState = [self.sequence objectAtIndex:(sequenceIdx+1)];
    NSLog(@"%@ -> %@", state, nextState);
    sequenceIdx += 1;
}

@end
