//
//  ResultsViewController.h
//  CellScope
//
//  Created by Matthew Bakalar on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultsViewController;

@protocol ResultsViewControllerDelegate <NSObject>
- (void)resultsViewControllerDone:(ResultsViewController *)controller;
@end

@interface ResultsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *resultsImage;
@property (weak, nonatomic) id <ResultsViewControllerDelegate> delegate;

- (IBAction)onDone:(id)sender;

@end
