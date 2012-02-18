
#import "Book.h"
#import "SDL_uikitappdelegate.h"

#define kFilename		@"data1.plist"
@class WToolbarController;


@interface CdDetailViewController : UITableViewController <UIWebViewDelegate,UIActionSheetDelegate> {
   	NSDateFormatter *dateFormatter;
	//NSUndoManager *undoManager;
	IBOutlet UIButton *button;
	WToolbarController* theToolbarController;
    UIWebView *webView;
	Book *book;
	NSString *url;
	NSString *dcTitle;
	//NSManagedObjectContext *managedContext;

}


@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) Book	*book;
//@property (nonatomic, retain) NSManagedObjectContext	*managedContext;

@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) WToolbarController* theToolbarController;
@property (nonatomic, retain) UIWebView *webView;

 
- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;
- (void)playMovie:(NSString*)movieURL;
-(void)playWithWeb:(NSString*)movieURL;
- (void)playCustom:(NSString*)movieURL;
- (void)setUrl:(NSString*)urlString;
- (void)setDcTitle:(NSString*)titleString; 


@end

