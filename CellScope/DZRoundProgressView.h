//
//  DZRoundProgressView.h
//  CellScope
//
//  Created by Matthew Bakalar on 4/8/12.
//  Credit goes to: http://stackoverflow.com/questions/8197239/animated-cashapelayer-pie
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DZRoundProgressLayer : CALayer

@property (nonatomic) CGFloat progress;

@end

@interface DZRoundProgressView : UIView

@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
