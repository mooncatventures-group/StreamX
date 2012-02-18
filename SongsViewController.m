#import "SongsViewController.h"
//#import "SongDetailsController.h"
//#import "Song.h"
#import "ContentsViewController.h"
#import "CdDetailViewController.h"
@implementation SongsViewController

@synthesize  tableView , fetchSectioningControl;

NSMutableArray *discoveredWebServices;
NSNetServiceBrowser *bonjourBrowser;

//START:code.BonjourWebBrowser.startSearchingForWebServers
-(void) startSearchingForWebServers {
	bonjourBrowser = [[NSNetServiceBrowser alloc] init];
	[bonjourBrowser setDelegate: self];
	//if ([fetchSectioningControl selectedSegmentIndex] == 0) {
	[bonjourBrowser searchForServicesOfType:@"_witap._tcp" inDomain:@""]; //<label id="code.BonjourWebBrowser.startSearchingForWebServers.searchforservicesoftype"/>
	//}else {
			
	// [bonjourBrowser searchForServicesOfType:@"_services._dns-sd._udp." inDomain:@""];	
	//}
	//[tableView reloadData];

	}
//END:code.BonjourWebBrowser.startSearchingForWebServers

// bonjour delegate methods
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
	//[activityIndicator startAnimating];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
	//[activityIndicator stopAnimating];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
	//[activityIndicator stopAnimating];
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	[discoveredWebServices addObject: netService];
	[tableView reloadData];
	//if (! moreServicesComing)
	//	[activityIndicator stopAnimating];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	[discoveredWebServices removeObject: netService];
	[tableView reloadData];
}


// resolution delegate methods
- (void)netServiceDidResolveAddress:(NSNetService *)aService {
	
	if (aService != NULL) {
		
		
		NSDictionary *txtRecordDictionary = //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.start"/>
		[NSNetService dictionaryFromTXTRecordData:
		 [aService TXTRecordData]];
		NSData *pathData =
		(NSData*) [txtRecordDictionary objectForKey: @"path"];
		NSString *path = [[NSString alloc] initWithData: pathData
											   encoding:NSUTF8StringEncoding];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.end"/>
		
		NSData *portData =
		(NSData*) [txtRecordDictionary objectForKey: @"port"];
		NSString *port = [[NSString alloc] initWithData: portData
											   encoding:NSUTF8StringEncoding];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.end"/>
		
		
		// build URL from host, port, and path
		
		
		NSRange range = [path rangeOfString : @"uuid:"];
		NSLog(path);
		
		if (range.location != NSNotFound) {
			urlString = [[NSString alloc]  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.buildurl.start"/>
						 initWithFormat: @"http://%@:%@/?UDN=%@&id=",
						 [aService hostName],
						 port,
						 path];
			NSLog(@"this is a media server %@", urlString);
			NSLog([aService hostName]);
			NSLog(path);
			
			[self jsonFromURLString:urlString forId:@"0" ];	
		}
	
	}
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	
}

- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.title = @"Discovered Web Services";
	discoveredWebServices = [[NSMutableArray alloc] initWithCapacity: 10]; // arbitrary initial capacity
	[self startSearchingForWebServers];
}




- (void)viewDidUnload {
    [super viewDidUnload];
   
}
/*

- (SongDetailsController *)detailController {
    if (detailController == nil) {
        detailController = [[SongDetailsController alloc] initWithNibName:@"SongDetailsView" bundle:nil];
    }
    return detailController;
}
 */

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark Table View


	
	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		return 1;
	}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [discoveredWebServices count];
}


- (IBAction)changeFetchSectioning:(id)sender {
}	

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
     return [NSString stringWithFormat:@"found - %d services", [discoveredWebServices count]];
    }

	
	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		// navigate to a web view for that service
		
		NSNetService *aService = (NSNetService	*) [discoveredWebServices objectAtIndex: [indexPath row]];
		if (aService != NULL) {
			
			[aService setDelegate: self];
			[aService resolveWithTimeout:10];
		}
		
		/*
		 WebPageViewController *webPageViewController = [[WebPageViewController alloc]
		 initWithNibName:@"WebPageView" bundle:nil netService:aService];
		 [self.navigationController pushViewController:webPageViewController animated:YES];
		 // [webPageViewController release];
		 }
		 */
	}
	
	
		- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
			
			static NSString *CellIdentifier = @"Cell";

			UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

			}
			
			// Set up the cell
			NSNetService *aService = (NSNetService*) [discoveredWebServices objectAtIndex: [indexPath row]];
			if (aService != NULL)
			cell.textLabel.text = [aService name];
			cell.detailTextLabel.text  = [NSString stringWithFormat:[aService type]];	
			 cell.imageView.image = [UIImage imageNamed:@"streaming.png"]; 
		
			[cell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0]];
			[cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
			[cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
			[cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];	
			[cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
			[cell.textLabel setTextColor:[UIColor blackColor]];
			[cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];

			cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
			
			
			return cell;
			
		
		}

	

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

#pragma mark WebServiceCommunication

// This will issue a request to a web service API via HTTP GET to the URL specified by urlString.
// It will return the JSON string returned from the HTTP GET.
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId  {
	
	NSString *urlWithId = [[NSString alloc] 
						   initWithFormat: @"%@%@",
						   thisUrl,
						   thisId];
	
	
	
	NSURL *url = [NSURL URLWithString:urlWithId];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	responseData = [[NSMutableData data] retain];
	
	NSURLConnection  *connection   = [[NSURLConnection alloc]
									  initWithRequest:request delegate:self];
	
}	

// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error {
	if (error != nil) {
		UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[errorAlertView show];
		[errorAlertView release];
	}  
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self handleError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	NSString *theString = [[NSString alloc] initWithData:responseData
												encoding:NSASCIIStringEncoding];
	
	
	
	
    ContentsViewController *cdDirectory = [[ContentsViewController alloc] initWithNibName:@"ContentsView" bundle:nil] ;
	
	
	
	[cdDirectory initWithJson:theString	forDomain:urlString];
	
	cdDirectory.hidesBottomBarWhenPushed = YES;

	[self.navigationController pushViewController:cdDirectory animated:YES];
	
	
	[cdDirectory release];
}


	
	- (void)dealloc {
		[bonjourBrowser release];
		[discoveredWebServices release];
		[super dealloc];
	}
	
	
@end
