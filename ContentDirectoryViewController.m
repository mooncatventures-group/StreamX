
#import "ContentDirectoryViewController.h"
#import "CJSONDeserializer.h"
#import "DetailViewController.h"
#import "CdDetailViewController.h"
#import "SongsViewController.h"
#import "CompositeSubviewBasedApplicationCell.h"
#import "HybridSubviewBasedApplicationCell.h"
#import	"CdDetailViewController.h"


@interface ContentDirectoryViewController (PrivateMethods)
- (void)handleError:(NSError *)error;
@end
#define USE_INDIVIDUAL_SUBVIEWS_CELL    1
#define USE_COMPOSITE_SUBVIEW_CELL      0
#define USE_HYBRID_CELL                 0


#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

@implementation ContentDirectoryViewController
@synthesize url,urlWithId;
@synthesize tmpCell;


@synthesize entityTableView;


- (void)viewDidLoad {
  [super viewDidLoad];
	
    entityTableView.rowHeight = 73.0;
    entityTableView.backgroundColor = LIGHT_BACKGROUND;
    entityTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

  entityTableView.dataSource = self;
  entityTableView.delegate = self;
  
}
 /*

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	entityTableView.dataSource = self;
	entityTableView.delegate = self;
}
*/


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}




- (void)dealloc {
  [items release];
  [super dealloc];
}

#pragma mark TableDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Items";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [items count];
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
		//CdDetailViewController *detailViewController = [[CdDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	    			 					 
		//[detailViewController setUrl:thisRes];
		//[detailViewController setDcTitle:thisItem];
		//detailViewController.hidesBottomBarWhenPushed = YES;
		//[self.navigationController pushViewController:detailViewController animated:YES];
		//[detailViewController release];
		
	}else {
	[self jsonFromURLString:url forId:thisKey];
	}
	 
	 }

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
    // Set up the cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
    cell.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}

	// Set the text of the cell to the tweet at the row
	cell.text = [items objectAtIndex:indexPath.row];
	return cell;
}
 
 */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplicationCell";
    
    ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		
#if USE_INDIVIDUAL_SUBVIEWS_CELL
        [[NSBundle mainBundle] loadNibNamed:@"IndividualSubviewsBasedApplicationCell" owner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
		
#elif USE_COMPOSITE_SUBVIEW_CELL
        cell = [[[CompositeSubviewBasedApplicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplicationCell"] autorelease];
		
#elif USE_HYBRID_CELL
        cell = [[[HybridSubviewBasedApplicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplicationCell"] autorelease];
#endif
    }
    
	// Display dark and light background in alternate rows -- see tableView:willDisplayCell:forRowAtIndexPath:.
    cell.useDarkBackground = (indexPath.row % 2 == 0);
	
	// Configure the data for the cell.
	
   // NSDictionary *dataItem = [data objectAtIndex:indexPath.row];
    cell.icon = [UIImage imageNamed:@"UpComing.png"];
    cell.publisher = @"";
    cell.name   = [items objectAtIndex:indexPath.row];
    cell.type = @"media";
	
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
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
  


    NSInteger *count=0;
	NSArray *cdObjectsArray = [resultsDictionary objectForKey:@"results"];
  for (NSDictionary *cdObjectsDictionary in cdObjectsArray) {
    NSString *itemTitle = [cdObjectsDictionary objectForKey:@"dctitle"];
	NSString *itemKey = [cdObjectsDictionary objectForKey:@"id"];
	NSString *itemClass = [cdObjectsDictionary objectForKey:@"upnpclass"];
	NSString *itemRes = [cdObjectsDictionary objectForKey:@"res"];
	  NSLog(itemRes);


	
    [items addObject:itemTitle];
	[keys  addObject:itemKey];
	[classes  addObject:itemClass];
	  if (itemRes !=nil) {
	[res  addObject:itemRes];
	  }else {
	[res  addObject:@"none"];
	  }


	 
	
  }
	
	if ([items count]==0) {
		[items addObject:@"No Content"];
		[keys addObject:@""];
		[classes addObject:@"object.item.Empty"];
	}
	
	  
  // refresh table view
  [entityTableView reloadData];
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
	
	
	
   	
	ContentDirectoryViewController *dsController = [[ContentDirectoryViewController alloc] initWithNibName:@"ContentDirectoryViewController" bundle:nil];
	    

	NSString *aString = [dsController initWithJson:theString	forDomain:url];
	NSLog(@"url is");
	//NSLog(urlWithId);
//	NSLog(theString);
	//NSLog(aString);
	     
				 
	   		
	     
		[self.navigationController pushViewController:dsController animated:YES];
				[dsController release];
	
		
	
		
	
	
}



@end
