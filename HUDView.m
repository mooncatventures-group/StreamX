#import "HUDView.h"
#import "SDL_keyboard_c.h"
#import "keyinfotable.h"



@implementation HUDView


- (id)initWithFrame:(CGRect)frame andText:(NSString *)txt {
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
	}
	text = [txt copy];
	return self;
}


- (void)drawRect:(CGRect)rect {
	self.alpha = .75;
			
	UIButton *rewindButton = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 64.0f, 64.0f)];
	[rewindButton setBackgroundImage:[[UIImage imageNamed:@"prev.png"] stretchableImageWithLeftCapWidth:64.0 topCapHeight:0.0] forState:UIControlStateNormal];
	//[stopButton setCenter:CGPointMake(195.0f, 208.0f)];
    rewindButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	[rewindButton addTarget:self action:@selector(rwClicked)
		 forControlEvents:UIControlEventTouchUpInside];

	[self addSubview:rewindButton];
	
	UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(72, 0, 64.0f, 64.0f)];
	[playButton setBackgroundImage:[[UIImage imageNamed:@"pause.png"] stretchableImageWithLeftCapWidth:64.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[playButton setBackgroundImage:[[UIImage imageNamed:@"play.png"] stretchableImageWithLeftCapWidth:64.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    playButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	[playButton addTarget:self action:@selector(playPauseToggled:)
		 forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:playButton];
	
	UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(136, 0, 64.0f, 64.0f)];
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"next.png"] stretchableImageWithLeftCapWidth:64.0 topCapHeight:0.0] forState:UIControlStateNormal];
	//[stopButton setCenter:CGPointMake(195.0f, 208.0f)];
    nextButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [nextButton addTarget:self action:@selector(ffClicked)
		 forControlEvents:UIControlEventTouchUpInside];

	[self addSubview:nextButton];
	
	UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 10, 48.0f, 48.0f)];
	[quitButton setBackgroundImage:[[UIImage imageNamed:@"quit.png"] stretchableImageWithLeftCapWidth:48.0 topCapHeight:0.0] forState:UIControlStateNormal];
	//[stopButton setCenter:CGPointMake(195.0f, 208.0f)];
    quitButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
   [quitButton addTarget:self action:@selector(quitClicked)
	forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:quitButton];
	
	
	
			
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat radius = 15;
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = floor(CGRectGetMidY(rect)), maxy = CGRectGetMaxY(rect);
	
	CGMutablePathRef clipPath = CGPathCreateMutable();
	// start at mid left
	CGPathMoveToPoint(clipPath, NULL, minx, midy);
	// add upper left arc
	CGPathAddArcToPoint(clipPath, NULL, minx, miny, midx, miny, radius);
	// add upper right arc
	CGPathAddArcToPoint(clipPath, NULL, maxx, miny, maxx, midy, radius);
	// add lower right arc
	CGPathAddArcToPoint(clipPath, NULL, maxx, maxy, midx, maxy, radius);
	// add lower left arc
	CGPathAddArcToPoint(clipPath, NULL, minx, maxy, minx, midy, radius);
	// close path
	CGPathCloseSubpath(clipPath);
	// add path to context
	CGContextAddPath(context, clipPath);
	
	CGContextSaveGState(context);
	CGContextClip(context);
	CGPathRelease(clipPath);
	
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	UIRectFill(CGRectMake(minx, miny, rect.size.width, rect.size.height));
	
	CGContextRestoreGState(context);
//	[aiv release];
		
}


-(void)quitClicked {
  
	SDL_KeyboardEvent event;
    event.type = SDL_KEYDOWN;
    event.which = 0;
    event.state = SDL_PRESSED;
    event.keysym.sym = SDLK_F11;
    SDL_PushEvent((SDL_Event*)&event);  // Send the F11 key press
    event.type = SDL_KEYUP;
    event.state = SDL_RELEASED;
    SDL_PushEvent((SDL_Event*)&event);  // Send the F11 key release

}


-(void)rwClicked {
	
	SDL_KeyboardEvent event;
    event.type = SDL_KEYDOWN;
    event.which = 0;
    event.state = SDL_PRESSED;
    event.keysym.sym = SDLK_LEFT;
    SDL_PushEvent((SDL_Event*)&event);  // Send the  key press
  	
}

-(void)ffClicked {
	
	SDL_KeyboardEvent event;
    event.type = SDL_KEYDOWN;
    event.which = 0;
    event.state = SDL_PRESSED;
    event.keysym.sym = SDLK_RIGHT;
    SDL_PushEvent((SDL_Event*)&event);  // Send the  key press
  	
}



- (void)playPauseToggled:(UIButton*)button {
	
	 
	button.highlighted = !button.highlighted;
	
	SDL_KeyboardEvent event;
    event.type = SDL_KEYDOWN;
    event.which = 0;
    event.state = SDL_PRESSED;
    event.keysym.sym = SDLK_F12;
    SDL_PushEvent((SDL_Event*)&event);  // Send the F12 key press
 	
}



- (void)dealloc {
	[super dealloc];
}


@end
