#import <UIKit/UIKit.h>


@interface MyOverlayView : UIView {
}

- (id)initWithView;       
- (void)dealloc;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
