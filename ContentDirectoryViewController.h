
#import <UIKit/UIKit.h>
#import "ApplicationCell.h"

@interface ContentDirectoryViewController : UIViewController < UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *entityTableView;
  NSMutableArray *items;
  NSMutableArray *keys;
  NSMutableArray *res;
  NSMutableArray *classes;
  NSString *url;
  NSString *urlWithId;

  NSMutableData *responseData;
  ApplicationCell *tmpCell;

 
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlWithId;
@property (nonatomic, assign) IBOutlet ApplicationCell *tmpCell;
@property (nonatomic, retain) IBOutlet UITableView *entityTableView;
- (NSString*) initWithJson:(NSString*)dataString forDomain:(NSString*)domain;
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId;

@end

