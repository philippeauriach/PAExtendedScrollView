//
//  PAExtendedScrollView.h
//
//  Created by Philippe Auriach on 25/08/13.
//  Based on the work by Björn Sållarp on 7/14/10 (http://blog.sallarp.com)
//
//  MIT License.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class PAExtendedScrollView;

@protocol PAExtendedScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(PAExtendedScrollView*)scrollView index:(int)index;
-(int)numberOfItemForScrollView:(PAExtendedScrollView*)scrollView;

@optional
-(void)scrollViewDidScroll:(PAExtendedScrollView*)scrollview;
-(void)scrollViewDidEndDecelerating:(PAExtendedScrollView*)scrollView;

@end


@interface PAExtendedScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id<PAExtendedScrollViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<PAExtendedScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;

- (void)didReceiveMemoryWarning;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;
- (int)currentPage;

@end
