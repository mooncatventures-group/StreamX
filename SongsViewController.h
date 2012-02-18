
#import <UIKit/UIKit.h>

//@class SongDetailsController;

@interface SongsViewController : UIViewController {
@private
  //  SongDetailsController *detailController;
//	NSManagedObjectContext *managedObjectContext;
    UITableView *tableView;
	NSMutableData *responseData;
	NSString *urlString;
    UISegmentedControl *fetchSectioningControl;
}
//@property (nonatomic, retain, readonly) SongDetailsController *detailController;
//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fetchSectioningControl;- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId; 
-(id)initWithTabBar;
- (IBAction)changeFetchSectioning:(id)sender;
- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId; 

@end
