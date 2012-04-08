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
}

@synthesize sequence;
@synthesize states;

- (id)init
{
    self = [super init];
    if(self) {
        sequenceIdx = 0;
        NSLog(@"Initializing the UserSequence");
        self.states = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Tap camera to record video", @"CollectImage",
                    @"Find new field of view, then tap camera to record video", @"Reposition", 
                    @"Done", @"Done",
                    nil];
        self.sequence = [NSArray arrayWithObjects: @"CollectImage", @"Reposition", @"CollectImage", @"Reposition", @"CollectImage", @"Reposition", @"CollectImage", @"Done", nil];
    }
    return self;
}

- (NSString*)nextMessage
{
    NSString *state = [self.sequence objectAtIndex:sequenceIdx];
    NSString *message = [self.states objectForKey:state];
    sequenceIdx += 1;
    return message;
}

@end
