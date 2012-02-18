//
//  SDLArtViewController.m
//  StreamX
//
//  Created by Michelle on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SDLArtViewController.h"


@implementation SDLArtViewController
@synthesize tabBar;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

*/


-(id) initWithTabBar {
	if ([self init]) {
		//this is the label on the tab button itself
		self.title = @"Rectangles";
		
		//use whatever image you want and add it to your project
		self.tabBarItem.image = [UIImage imageNamed:@"Cloud.png"];
		
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"Rectangles";
	}
	return self;
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:NO];
	tabBar.selectedItem = [tabBar.items objectAtIndex:0];
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	[appDelegate postProcessing:@"1"];
	
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
