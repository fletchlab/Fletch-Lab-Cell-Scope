//
//  PictureInstructionSequence.h
//  CellScope
//
//  Created by Matthew Bakalar on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureInstructionSequence : NSObject

@property (nonatomic, retain) NSArray* sequence;
@property (nonatomic, retain) NSDictionary* states;
@property (nonatomic, retain) NSDictionary* images;

- (NSString*)currentMessage;
- (NSString*)currentImage;
- (void)advanceSequence;
- (BOOL)returnToCapture;
- (BOOL)atFirstState;
- (NSString*)state;

@end
