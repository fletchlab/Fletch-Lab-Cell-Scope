//
//  ResultsViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "CollectImagesViewController.h"
@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize num_mfR;
@synthesize resultsImage;
@synthesize delegate;
@synthesize collectImageViewController;
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
    //int mf_num=[self.collectImageViewController getMF];
    NSLog(@"num_mf=%i", self.num_mfR);

    //int number = (arc4random()%100)+1; //Generates Number from 1 to 100.
    if (self.num_mfR > 50) {
        self.resultsImage.image = [UIImage imageNamed:@"Results_50000.png"];
    }
}

- (void)viewDidUnload
{
    [self setResultsImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onDone:(id)sender {
    [delegate resultsViewControllerDone:self];
}
-(void) setMFR:(int) num_mf_temp3{
    self.num_mfR=num_mf_temp3/4;
}

@end
