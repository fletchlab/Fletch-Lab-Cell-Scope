//
//  UserSequence.h
//  CellScope
//
//  Created by Matthew Bakalar on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSequence : NSObject

@property (nonatomic, retain) NSArray* sequence;
@property (nonatomic, retain) NSDictionary* states;

- (NSString*)nextMessage;

@end
