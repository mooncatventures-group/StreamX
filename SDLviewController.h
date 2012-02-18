//
//  SDLviewController.h
//  StreamX
//
//  Created by Michelle on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDL_uikitappdelegate.h"

@interface SDLviewController : UIViewController {
IBOutlet UITabBar *tabBar;
NSString *url;
UIView *overlayView;
UILabel *overlayLabel;



}
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UILabel *overlayLabel;
@property (nonatomic, retain) UITabBar *tabBar;
@property (nonatomic, retain) NSString *url;
-(id)initWithTabBar;
- (void)setUrl:(NSString*)thisUrl;
@end
