#import "CdDetailViewController.h"
#import "Book.h"
#import "EditingViewController.h"
#import	"WToolbarController.h"
#import "SDLviewController.h"
#import <MediaPlayer/MediaPlayer.h>
#define OVERLAY_ALPHA 0.0f
@implementation CdDetailViewController
@synthesize dateFormatter, undoManager;
@synthesize button;
@synthesize theToolbarController;
@synthesize webView;
@synthesize book;
//@synthesize managedContext;


#pragma mark -
#pragma mark View lifecycle

- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

/*
- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"Info";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//self.tableView.allowsSelectionDuringEditing = YES;
	theToolbarController = [[WToolbarController alloc] init];
	theToolbarController.delegate = self;
	[self.view addSubview: theToolbarController.theToolbar];
	[theToolbarController.theToolbar release];
	//[updateToolbarItemStatus];
	
	

	
	
}
 */



- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView reloadData];
	[self becomeFirstResponder];
}




- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
	[self updateRightBarButtonItemState];
	
	}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
	}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.dateFormatter = nil;
}


- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [book validateForUpdate:NULL];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 3 rows

  
	if (section==0) return 0;
	if (section==1) return 0;
	if (section==2) return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
		
	if (indexPath.section==2) {
		switch (indexPath.row) {
	
		
        case 0: 
			cell.textLabel.text = @"Title";
			cell.detailTextLabel.text = dcTitle;
			break;
        case 1: 
			cell.textLabel.text = @"bookmark";
			cell.detailTextLabel.text = book.bookmark;
			break;
        case 2:
				cell.textLabel.text = @"url for Web";
				cell.detailTextLabel.text = url;
			//cell.textLabel.text = @"date";
			//cell.detailTextLabel.text = [self.dateFormatter stringFromDate:book.date];
			break;
		case 3:
			cell.textLabel.text = @"url";
		
				cell.detailTextLabel.text = url;
			break;
			
		
	}
	}
	
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
			return indexPath;
	
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"and now this one");
	//if (!self.editing) {
	if (indexPath.row==3) {
		//button.hidden=NO;
		if([url hasSuffix:@".jpg"]==YES || [url hasSuffix:@"png"]==YES  || [url hasSuffix:@"PNG"]==YES  || [url hasSuffix:@"JPG"]==YES){
		//	PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
		//	photoViewController.hidesBottomBarWhenPushed = YES;
		//	[photoViewController setUrl:url];
		//	[self.navigationController pushViewController:photoViewController animated:YES];
		//[photoViewController release];

		}else {
			if([url hasSuffix:@".mpeg"]==YES || [url hasSuffix:@".avi"]==YES || [url hasSuffix:@"AVI"]==YES ||  [url hasSuffix:@"MPG"]==YES || [url hasSuffix:@"mpg"] == YES){
				[self playCustom:url];
			}else{
			
			[self playMovie:url];
			}

		}
	}
	

}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


- (void)clickActionItem
{
	
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Email Link", 
								  @"Open in Safari", 
								  @"Cancel", nil];
	actionSheet.tag = 5;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 2;	
	[actionSheet showInView:self.view];
	[actionSheet release];
	
	}


- (void)clickAddItem
{
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"bookmark", 
								  @"Open in Safari", 
								  @"Cancel", nil];
	actionSheet.tag = 5;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 2;	
	[actionSheet showInView:self.view];
	[actionSheet release];
	
	
	 
}



- (void)clickNextItem
{
   
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Play As Web Link",
								  @"Play With Media Player", 
								  @"Cancel", nil];
	actionSheet.tag = 4;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 3;
	[actionSheet showInView:self.view];
	[actionSheet release];
	
		
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
		
	if(4 == actionSheet.tag)
	{
		if(0 == buttonIndex)//save page
		{    
			CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
			webFrame.origin.y -= 20.0;	// shift the display up so that it covers the default open space from the content view
			//webFrame.size.height -=toolbarHeight;
			
			UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
			self.webView = aWebView;
			aWebView.scalesPageToFit = YES;
			aWebView.autoresizesSubviews = YES;
			aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			//set the web view delegate for the web view to be itself
			//[aWebView setDelegate:self];
			
			//determine the path the to the index.html file in the Resources directory
			//NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
			//build the URL and the request for the index.html file
			//NSURL *aURL = [NSURL fileURLWithPath:filePathString];
			NSURL *aURL = [NSURL URLWithString:url];
			
			NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
			
			//load the index.html file into the web view.
			[aWebView loadRequest:aRequest];
			return;
			
			
		}
		else if(1 == buttonIndex)
		{
			   if([url hasSuffix:@".m4v"]==YES || [url hasSuffix:@"mp4"]==YES ||  [url hasSuffix:@"mp4"]==YES || [url hasSuffix:@"m3u8"] == YES){
				NSLog(@"my url");
				   NSLog(url);
				   [self playMovie:url];
				return;
				
			}
			
			
				}
				
	}
	else if(5 == actionSheet.tag)
	{
		if(0 == buttonIndex)//email link
			
		{ 
							
			
				
		
		}
		
		else if(1 == buttonIndex)//open in safari
		{
				//NSString* url = [[NSString alloc] initWithFormat:@"%@wiki/%@", http, page];
				//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:book.url]];
				//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
				//[url release];
			
			
			//create a frame that will be used to size and place the web view
			CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
			webFrame.origin.y -= 20.0;	// shift the display up so that it covers the default open space from the content view
			//webFrame.size.height -=toolbarHeight;
			
			UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
			self.webView = aWebView;
			/*
			 *	Uncomment the following line if you want the HTML to scale to fit.  
			 *	This also allows the pinch zoom in and out functionality to work.
			 */
			aWebView.scalesPageToFit = YES;
			aWebView.autoresizesSubviews = YES;
			aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			//set the web view delegate for the web view to be itself
			[aWebView setDelegate:self];
			
			//determine the path the to the index.html file in the Resources directory
			//NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
			//build the URL and the request for the index.html file
			NSURL *aURL = [NSURL URLWithString:url];
			NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
			
			
			//load the index.html file into the web view.
			[aWebView loadRequest:aRequest];
			
			//add the web view to the content view
			addSubview:webView;
			
			
			
			
			
				}
		else if(2 == buttonIndex)//cancel
		{
						
						
		}
	}
	
	
}



- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}

   -(void)action:(id)sender
    {
	        NSLog(@"UIButton was clicked");
	       	    }


#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

-(void)movieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie = [aNotification object];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:theMovie];
	
    // Release the movie instance created in playMovieAtURL:
    [theMovie release];
}

- (void)playMovie:(NSString*)movieURL
{
		
	MPMoviePlayerController* theMovie = [[MPMoviePlayerController alloc] initWithContentURL:
										 [NSURL URLWithString:movieURL]];
	theMovie.scalingMode = MPMovieScalingModeAspectFill;
	theMovie.movieControlMode = MPMovieControlModeDefault;
	
	// Register for the playback finished notification.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:theMovie];
	
	// Movie playback is asynchronous, so this method returns immediately.
	[theMovie play];
}

-(void)playCustom:(NSString*)movieURL
{
	
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
	
	SDLviewController *sdlViewController = [[SDLviewController alloc] initWithTabBar];
	
	[sdlViewController setUrl:movieURL ];
	sdlViewController.hidesBottomBarWhenPushed = YES;
	UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	overlayView.opaque = NO;
	overlayView.alpha = OVERLAY_ALPHA;
   	sdlViewController.view = overlayView;
	[self.navigationController pushViewController:sdlViewController animated:YES];
	[sdlViewController release];
	
	

}

- (void)setUrl:(NSString*)urlString 
{
	url = urlString;
}

- (void)setDcTitle:(NSString*)titleString 
{
	dcTitle = titleString;
}



-(void)playWithWeb:(NSString*)movieURL
{
	
	//create a frame that will be used to size and place the web view
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y -= 20.0;	// shift the display up so that it covers the default open space from the content view
	//webFrame.size.height -=toolbarHeight;
	
	UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
	self.webView = aWebView;
	/*
	 *	Uncomment the following line if you want the HTML to scale to fit.  
	 *	This also allows the pinch zoom in and out functionality to work.
	 */
	aWebView.scalesPageToFit = YES;
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	//set the web view delegate for the web view to be itself
	[aWebView setDelegate:self];
	
	//determine the path the to the index.html file in the Resources directory
	//NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	//build the URL and the request for the index.html file
	NSURL *aURL = [NSURL URLWithString:url];
	NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
	
	
	//load the index.html file into the web view.
	[aWebView loadRequest:aRequest];
	
	//add the web view to the content view
addSubview:webView;
	
	
		
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  //  [undoManager release];
    [dateFormatter release];
	[theToolbarController release];
    [book release];
    [super dealloc];
}

@end

