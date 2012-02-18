@interface HUDView : UIView {
NSString *text;
}
- (id)initWithFrame:(CGRect)frame andText:(NSString *)txt;
-(void)quitClicked;
-(void)playPauseToggled:(UIButton*)button;
-(void)rwClicked;
-(void)ffClicked;
@end