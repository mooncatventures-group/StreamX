#import "SongsViewController.h"
//#import "SongDetailsController.h"
#import "ContentsViewController.h"
#import "CJSONDeserializer.h"
#import "CdDetailViewController.h"


@implementation ContentsViewController

@synthesize tableView , fetchSectioningControl;
@synthesize url,urlWithId;


- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	}




- (void)viewDidUnload {
    [super viewDidUnload];
   
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark Table View


	
	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		return 1;
	}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	tableView.rowHeight = 50.0;
	return [items count];
}


- (IBAction)changeFetchSectioning:(id)sender {
}	

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
		return [NSString stringWithFormat:@"found - %d items", [items count]];
    }
	
	
	
	
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
			
			static NSString *CellIdentifier = @"Cell";

			UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

			}
			
			// Set up the cell
			cell.textLabel.text = [items objectAtIndex:indexPath.row];

			
	       
	       if ([albumArt objectAtIndex:indexPath.row]!=@"none") {
			   NSURL *sURL = [NSURL URLWithString:[albumArt objectAtIndex:indexPath.row]];
			   NSData *sData = [NSData dataWithContentsOfURL:sURL];
			   UIImage *image = [[UIImage alloc] initWithData:sData];
			   CGRect rect = CGRectMake(0.0, 0.0, 50, 50);
			   UIGraphicsBeginImageContext(rect.size);
			   [image drawInRect:rect];
			   cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
			   //cell.detailTextLabel.text = src;
			   UIGraphicsEndImageContext();
	       }else {
		    cell.imageView.image = [UIImage imageNamed:@"Upcoming.png"];
			   
		   }
			cell.detailTextLabel.text  = [NSString stringWithFormat:@"media"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *thisKey = [keys objectAtIndex:indexPath.row];
	NSString *thisRes = [res objectAtIndex:indexPath.row];
	NSString *thisItem = [items objectAtIndex:indexPath.row];
	
	
	NSLog(@"this key");
	NSLog(url);
	
	NSLog(@"title");
	NSLog(thisItem);
	
	NSLog(@"res");
	NSLog(thisRes);
	
	
	if (thisRes!=@"none") {
		NSLog(@"foundone");
	   CdDetailViewController *detailViewController = [[CdDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		[detailViewController setUrl:thisRes];
		[detailViewController setDcTitle:thisItem];
		detailViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		
	}else {
		[self jsonFromURLString:url forId:thisKey];
	}
	
}


// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error {
	if (error != nil) {
		UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[errorAlertView show];
		[errorAlertView release];
	}  
	
}

- (NSString*) initWithJson:(NSString*)dataString forDomain:(NSString*)domain  {
	
	
	items = [[NSMutableArray alloc] init];
	keys = [[NSMutableArray alloc] init];
	classes = [[NSMutableArray alloc] init];
	res = [[NSMutableArray alloc] init];
	albumArt = [[NSMutableArray alloc] init];
	url = domain;
	
	NSData *jsonData = [dataString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	
	// Parse JSON results with TouchJSON.  It converts it into a dictionary.
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSError *error = nil;
	NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:nil];
	[self handleError:error];
	
	// Clear out the old tweets from the previous search
	[items removeAllObjects];
	[keys removeAllObjects];
	[classes removeAllObjects];
	[res removeAllObjects];
	[albumArt removeAllObjects];

	
	
    NSInteger *count=0;
	NSArray *cdObjectsArray = [resultsDictionary objectForKey:@"results"];
	for (NSDictionary *cdObjectsDictionary in cdObjectsArray) {
		NSString *itemTitle = [cdObjectsDictionary objectForKey:@"dctitle"];
		NSString *itemKey = [cdObjectsDictionary objectForKey:@"id"];
		NSString *itemClass = [cdObjectsDictionary objectForKey:@"upnpclass"];
		NSString *itemRes = [cdObjectsDictionary objectForKey:@"res"];
		NSString *artUri = [cdObjectsDictionary objectForKey:@"upnpalbumArtURI"];
		NSString *tvsUri = [cdObjectsDictionary objectForKey:@"upnpicon"];
				NSLog(itemRes);
		NSLog(@"albumart %@ ", artUri);
		NSLog(@"albumicon %@ ", tvsUri);
		
		
		[items addObject:itemTitle];
		[keys  addObject:itemKey];
		[classes  addObject:itemClass];
		if (itemRes !=nil) {
			[res  addObject:itemRes];
		}else {
			[res  addObject:@"none"];
		}
		
		if (artUri !=nil || artUri !=NULL) {
			[albumArt addObject:artUri];
		}else {
			if (tvsUri !=nil || tvsUri !=NULL) {
		    [albumArt addObject:tvsUri];
			} else {
		
			[albumArt addObject:@"none"];
			}
		}
		
		
	}
	
	if ([items count]==0) {
		[items addObject:@"No Content"];
		[keys addObject:@""];
		[classes addObject:@"object.item.Empty"];
		[albumArt addObject:@"none"];
	}
	
	
	// refresh table view
	[tableView reloadData];
	return [classes objectAtIndex:0];
	
}

#pragma mark WebServiceCommunication

// This will issue a request to a web service API via HTTP GET to the URL specified by urlString.
// It will return the JSON string returned from the HTTP GET.
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId  {
	
	urlWithId = [[NSString alloc] 
				 initWithFormat: @"%@%@",
				 thisUrl,
				 thisId];
	
	
	
	
	NSURL *aurl = [NSURL URLWithString:urlWithId];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:aurl];
	[request setHTTPMethod:@"GET"];
	
	responseData = [[NSMutableData data] retain];
	
	NSURLConnection  *connection   = [[NSURLConnection alloc]
									  initWithRequest:request delegate:self];
	
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
	
	
	
   	
	ContentsViewController *dsController = [[ContentsViewController alloc] initWithNibName:@"ContentsView" bundle:nil];
	
	
	NSString *aString = [dsController initWithJson:theString	forDomain:url];
	NSLog(@"url is");
	//NSLog(urlWithId);
	//	NSLog(theString);
	//NSLog(aString);
	
	dsController.hidesBottomBarWhenPushed = YES;

	
	
	[self.navigationController pushViewController:dsController animated:YES];
		[dsController release];
	
	
	
	
	
	
}

	
	- (void)dealloc {
		
		[super dealloc];
	}
	
	
@end
