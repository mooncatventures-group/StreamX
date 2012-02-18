//
//  SDLviewController.m
//  StreamX
//
//  Created by Michelle on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SDLviewController.h"
#import "sdl.h"
#define OVERLAY_ALPHA 0.90f
#define BINOCS_TAG 99
#define BINOCS_BUTTON_TAG 100



@implementation SDLviewController

@synthesize tabBar;
@synthesize url;
@synthesize overlayView, overlayLabel;
 
 -(id) initWithTabBar {
 if ([self init]) {
 //this is the label on the tab button itself
 self.title = @"Player";
 
 //use whatever image you want and add it to your project
 self.tabBarItem.image = [UIImage imageNamed:@"note.png"];
 
 // set the long name shown in the navigation bar
 self.navigationItem.title=@"Player";
 }
 return self;
 
 }


 
- (void)viewDidAppear:(BOOL)animated {
		
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	NSString *glString = appDelegate.glInit;
	appDelegate.glInit =@"1";
	NSLog(@"pass stage 1");
	NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];
	[parms setObject: url forKey: @"url"];
	NSLog(@"set url");
    [parms setObject: glString forKey: @"glflag" ];
	NSLog(@"all objects set");
	[appDelegate postProcessing:parms];
		 
}


- (void)setUrl:(NSString*)thisUrl {
	url=thisUrl;
	/*
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	NSString *glString = appDelegate.glInit;
	appDelegate.glInit =@"1";
	NSLog(@"pass stage 1");
	NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];
	[parms setObject: url forKey: @"url"];
	NSLog(@"set url");
    [parms setObject: glString forKey: @"glflag" ];
	NSLog(@"all objects set");
	[appDelegate postProcessing:parms];
	
	*/
	
	
	
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
		NSLog(@"exit sdviewControler unload");
	
	
}
-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:NO];
	NSLog(@"exit sdviewControler");
	
	}


- (void)dealloc {
    [super dealloc];
}


@end
