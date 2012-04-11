//
//  LoaLoaMenuViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppMenuViewController.h"

@implementation AppMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CollectImagesPictureInstructions"])
	{
		CollectImagesViewController *collectImagesViewController = segue.destinationViewController;
        collectImagesViewController.delegate = self;
        collectImagesViewController.instructionMode = @"PictureInstructions";
	}
    else if ([segue.identifier isEqualToString:@"CollectImages"])
	{
		CollectImagesViewController *collectImagesViewController = segue.destinationViewController;
        collectImagesViewController.delegate = self;
        collectImagesViewController.instructionMode = @"None";
	}
}

#pragma mark - Collect Images Delegate

- (void)collectImagesViewDidCancel:(CollectImagesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectImagesViewSequenceComplete:(CollectImagesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
