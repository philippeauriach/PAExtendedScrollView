//
//  PAExtendedScrollView.m
//
//  Created by Philippe Auriach on 25/08/13.
//  Based on the work by Björn Sållarp on 7/14/10 (http://blog.sallarp.com)
//
//  MIT License.
//

#import "PAExtendedScrollView.h"

@implementation PAExtendedScrollView
@synthesize scrollView, pageSize=_pageSize, delegate=_delegate;

- (void)awakeFromNib
{
	firstLayout = YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		firstLayout = YES;
	}
	
	return self;
}

- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size 
{    
	if (self = [self initWithFrame:frame]) 
	{
		self.pageSize = size;
    }
    return self;
}

-(void)loadPage:(int)page
{
	// Sanity checks
    if (page < 0) return;
    if (page >= [scrollViewPages count]) return;
	
	// Check if the page is already loaded
	UIView *view = [scrollViewPages objectAtIndex:page];
	
	// if the view is null we request the view from our delegate
	if ((NSNull *)view == [NSNull null]) 
	{
		view = [self.delegate viewForItemAtIndex:self index:page];
		[scrollViewPages replaceObjectAtIndex:page withObject:view];
	}
	
	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) 
	{
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
		viewFrame.origin.y = 0;
		
		view.frame = viewFrame;
		
		[self.scrollView addSubview:view];
	}
}

- (void)layoutSubviews
{
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)
	{  
		// Position and size the scrollview. It will be centered in the view.
		CGRect scrollViewRect = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - self.pageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - self.pageSize.height) / 2);
		 
		scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		scrollView.clipsToBounds = NO; // Important, this creates the "preview"
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
		
		[self addSubview:scrollView];
		
		
		int pageCount = [self.delegate numberOfItemForScrollView:self];
		scrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
		
		// Fill our pages collection with empty placeholders
		for(int i = 0; i < pageCount; i++)
		{
			[scrollViewPages addObject:[NSNull null]];
		}
		
		// Calculate the size of all combined views that we are scrolling through 
		self.scrollView.contentSize = CGSizeMake([self.delegate numberOfItemForScrollView:self] * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
		
		// Load the first two pages
		[self loadPage:0];
		[self loadPage:1];
		
		firstLayout = NO;
	}
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) {
		return self.scrollView;
	}
	
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

-(int)currentPage
{
	// Calculate which page is visible 
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	return page;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)sv
{
	int page = [self currentPage];
	
	// Load the visible and neighbouring pages 
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
    
    if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:self];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self];
}

#pragma mark -
#pragma mark Memory management

// didReceiveMemoryWarning is not called automatically for views, 
// make sure you call it from your view controller
- (void)didReceiveMemoryWarning 
{
	// Calculate the current page in scroll view
    int currentPage = [self currentPage];
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [scrollViewPages count]; i++) 
	{
		UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
}


@end
