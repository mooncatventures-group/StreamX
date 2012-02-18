
#import "MyOverlayView.h"


@implementation MyOverlayView

// MPMoviePlayerController will play movies full-screen in 
// landscape mode, so we must rotate MyOverlayView 90 degrees and 
// translate it to the center of the screen so when it draws
// on top of the playing movie it will display in landscape 
// mode to match the movie player orientation.
//
- (id)initWithView;       
{
	CGAffineTransform transform = self.transform;

	// Rotate the view 90 degrees. 
	transform = CGAffineTransformRotate(transform, (M_PI / 2.0));

    UIScreen *screen = [UIScreen mainScreen];
    // Translate the view to the center of the screen
    transform = CGAffineTransformTranslate(transform, 
        ((screen.bounds.size.height) - (self.bounds.size.height))/2, 
        0);
	self.transform = transform;
	
	CGRect newFrame = self.frame;
	newFrame.origin.x = 190;
	self.frame = newFrame;
}

- (void)dealloc {
	[super dealloc];
}

// Handle any touches to the overlay view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan)
    {
        // IMPORTANT:
        // Touches to the overlay view are being handled using
        // two different techniques as described here:
        //
        // 1. Touches to the overlay view (not in the button)
        //
        // On touches to the view we will post a notification
        // "overlayViewTouch". MyMovieViewController is registered 
        // as an observer for this notification, and the 
        // overlayViewTouches: method in MyMovieViewController
        // will be called. 
        //
        // 2. Touches to the button 
        //
        // Touches to the button in this same view will 
        // trigger the MyMovieViewController overlayViewButtonPress:
        // action method instead.

       // NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      //  [nc postNotificationName:OverlayViewTouchNotification object:nil];

    }    
}


@end
