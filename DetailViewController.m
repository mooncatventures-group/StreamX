


#import "DetailViewController.h"
#import "Book.h"
#import "EditingViewController.h"
#import	"NTToolbarController.h"
//#import "PhotoViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation DetailViewController

@synthesize book, dateFormatter;
@synthesize button;
@synthesize theToolbarController;
@synthesize webView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Configure the title, title bar, and table view.
	self.title = @"Info";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.allowsSelectionDuringEditing = YES;
		theToolbarController = [[NTToolbarController alloc] init];
	theToolbarController.delegate = self;
	[self.view addSubview: theToolbarController.theToolbar];
	[theToolbarController.theToolbar release];
	//[updateToolbarItemStatus];
	
	
}


- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
	[self updateRightBarButtonItemState];
	
	}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.dateFormatter = nil;
}


- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [book validateForUpdate:NULL];
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
			cell.detailTextLabel.text = book.title;
			break;
        case 1: 
			cell.textLabel.text = @"bookmark";
			cell.detailTextLabel.text = book.bookmark;
			break;
        case 2:
			cell.textLabel.text = @"date";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:book.date];
			break;
		case 3:
			cell.textLabel.text = @"url";
			//book.url=@"http://qthttp.akamai.com.edgesuite.net/iphone_source/yahoo/nasa/nasa_all.m3u8";
			cell.detailTextLabel.text = book.url;
			break;
			
		
	}
	}
	
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return (self.editing) ? indexPath : nil;
  }

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.editing) {
		button.hidden=NO;
		return;
	}
	
	button.hidden=YES;
    EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
	if (indexPath.section !=2) return;
 //   controller.editedObject = book;
   if (indexPath.section==2 ) {
	switch (indexPath.row) {
        case 0: {
            controller.editedFieldKey = @"title";
            controller.editedFieldName = NSLocalizedString(@"title", @"display name for title");
            controller.editingDate = NO;
        } break;
        case 1: {
            controller.editedFieldKey = @"bookmark";
			controller.editedFieldName = NSLocalizedString(@"bookmark", @"display name for bookmark");
			controller.editingDate = NO;
        } break;
        case 2: {
            controller.editedFieldKey = @"date";
			controller.editedFieldName = NSLocalizedString(@"date", @"display name for date");
			controller.editingDate = YES;
        } break;
		case 3: {
            controller.editedFieldKey = @"url";
			controller.editedFieldName = NSLocalizedString(@"url", @"display name for url");
			controller.editingDate = NO;
        } break;
			
		
    }
	}
		
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
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
			NSURL *aURL = [NSURL URLWithString:book.url];
			
			NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
			
			//load the index.html file into the web view.
			[aWebView loadRequest:aRequest];
			return;
			
			
		}
		else if(1 == buttonIndex)//add to bookmark
		{
			
			   if([book.url hasSuffix:@".m4v"]==YES || [book.url hasSuffix:@"mp4"]==YES ||  [book.url hasSuffix:@"mov"]==YES || [book.url hasSuffix:@"m3u8"] == YES){
				[self playMovie:book.url];
				return;
				
			}
			
			
				}
				
	}
	else if(5 == actionSheet.tag)
	{
		if(0 == buttonIndex)//email link
		{     
			NSLog(@"must worked on iphone");
			NSString *text = @"mailto:?&subject=nothing&body=link from mediashare  on iPhone";
			NSURL *url = [[NSURL alloc] initWithString: [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:url];
			[url release];
		}
		else if(1 == buttonIndex)//open in safari
		{
				//NSString* url = [[NSString alloc] initWithFormat:@"%@wiki/%@", http, page];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:book.url]];
				//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
				//[url release];
			}
		}
		else if(2 == buttonIndex)//cancel
		{
						
						
		}
	
	
}



- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
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





#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [undoManager release];
    [dateFormatter release];
	[theToolbarController release];
    [book release];
    [super dealloc];
}

@end

