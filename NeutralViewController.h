//
//  NeutralViewController.h
//  StreamX
//
//  Created by Michelle on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDL_uikitappdelegate.h"

@interface NeutralViewController : UIViewController {
IBOutlet UITabBar *tabBar;	

}
@property (nonatomic, retain) UITabBar *tabBar;

-(id)initWithTabBar;
@end
