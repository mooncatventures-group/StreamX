//
//  WToolbarController.m
//
//  Created by xu on 4/19/09.
//  Copyright 2009 __mooncatventures.com__. All rights reserved.

#import "WToolbarController.h"


@implementation WToolbarController
@synthesize theToolbar, delegate;
@synthesize previousItem, nextItem, cancelandrefreshItem;
@synthesize cancelandrefreshItemType;

- (id)init
{
	if(self = [super init])
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	   	theToolbar = [[UIToolbar alloc] init];
		theToolbar.barStyle = UIBarStyleDefault;
		[theToolbar sizeToFit];
		CGRect toolbarFrame = appFrame;
		toolbarFrame.origin.y = toolbarFrame.size.height - theToolbar.frame.size.height*2;
		toolbarFrame.size.height = theToolbar.frame.size.height;
		[theToolbar setFrame:CGRectMake(toolbarFrame.origin.x,toolbarFrame.origin.y, toolbarFrame.size.width, toolbarFrame.size.height)];
		[self createToolbarItems];
	}
	
	return self;
}

- (void)createToolbarItems
{
	previousItem = [[UIBarButtonItem alloc]  initWithImage: [UIImage imageNamed:@"previous.png"]
										  style:UIBarButtonItemStylePlain
										target:self 
										action:@selector(clickPreviousItem)];
	
	UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
															      target:self 
																action:nil];
	
	nextItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
												target:self 
												action:@selector(clickNextItem)];
	
	UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				 target:self 
																				 action:nil];
	cancelandrefreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
															target: self
															action: @selector(clickCancelAndRefreshItem)];
	cancelandrefreshItemType = 0;
	
	UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				 target:self 
																				 action:nil];
	
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
															target:self 
															action:@selector(clickAddItem)];
	
	UIBarButtonItem *spaceItem3 = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																target:self 
																action:nil];
	
	UIBarButtonItem *actionItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																target:self 
																action:@selector(clickActionItem)];
	
	NSArray *items = [NSArray arrayWithObjects: previousItem, spaceItem, nextItem, spaceItem1, 
					                                 spaceItem2, addItem, spaceItem3, nil];
	[theToolbar setItems:items animated:NO];
	[previousItem release];
	[spaceItem release];
	[nextItem release];
	[spaceItem1 release];
	[cancelandrefreshItem release];
	[spaceItem2 release];
	[addItem release];
	[spaceItem3 release];
	[actionItem release];
}

- (void)clickPreviousItem
{
	if([delegate respondsToSelector: @selector(clickPreviousItem)])
		[delegate clickPreviousItem];
}

- (void)clickNextItem
{
	if([delegate respondsToSelector: @selector(clickNextItem)])
		[delegate clickNextItem];
}

- (void)clickCancelAndRefreshItem
{
	
	if(0 == cancelandrefreshItemType)
	{
		[self clickRefreshItem];
//		cancelandrefreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop
//																			 target: self
//																			 action: @selector(clickCancelAndRefreshItem)];
//		cancelandrefreshItemType = 1;
	}
	else if(1 == cancelandrefreshItemType)
	{
		[self clickCancelItem];
//		cancelandrefreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
//																			 target: self
//																			 action: @selector(clickCancelAndRefreshItem)];
//		cancelandrefreshItemType = 0;
	}
}

- (void)changeToRefreshItem
{
	cancelandrefreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
																		 target: self
																		 action: @selector(clickCancelAndRefreshItem)];
	cancelandrefreshItemType = 0;
	NSArray* items = [theToolbar items];
	NSMutableArray* newItems = [[NSMutableArray alloc] init];
	[newItems addObjectsFromArray: items];
	[newItems removeObjectAtIndex: 4];
	[newItems insertObject:cancelandrefreshItem atIndex: 4];
	[theToolbar setItems: newItems animated: NO];
}

- (void)changeToCancelItem
{
	cancelandrefreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop
																		 target: self
																		 action: @selector(clickCancelAndRefreshItem)];
	cancelandrefreshItemType = 1;
	NSArray* items = [theToolbar items];
	NSMutableArray* newItems = [[NSMutableArray alloc] init];
	[newItems addObjectsFromArray: items];
	[newItems removeObjectAtIndex: 4];
	[newItems insertObject:cancelandrefreshItem atIndex: 4];
	[theToolbar setItems: newItems animated: NO];
}

- (void)clickRefreshItem
{
	if([delegate respondsToSelector: @selector(clickRefreshItem)])
		[delegate clickRefreshItem];
}

- (void)clickCancelItem
{
	if([delegate respondsToSelector: @selector(clickCancelItem)])
		[delegate clickCancelItem];
}

- (void)clickAddItem
{
	if([delegate respondsToSelector: @selector(clickAddItem)])
		[delegate clickAddItem];
}

- (void)clickActionItem
{
	if([delegate respondsToSelector: @selector(clickActionItem)])
		[delegate clickActionItem];
}

- (void)dealloc
{
    [previousItem release];
    [nextItem release];
    [cancelandrefreshItem release];
    [delegate release];
    [theToolbar release];
    [super dealloc];
}

@end
