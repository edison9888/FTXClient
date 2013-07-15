//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"
#import "UIColor+FTX.h"

#define kFooterPullText @"上拉加载更多"
#define kFooterLoadingText @"努力加载中..."
#define kFooterReleaseText @"释放加载更多内容"

#define REFRESH_HEADER_HEIGHT 60

@interface EGORefreshTableFooterView ()
{
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation EGORefreshTableFooterView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), REFRESH_HEADER_HEIGHT)];
        footer.backgroundColor = [UIColor blackColor];
        [self addSubview:footer];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh-logo"]];
        logo.center = CGPointMake(35, REFRESH_HEADER_HEIGHT/2.0);
        [footer addSubview:logo];

        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, 100, 47)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.text = kFooterPullText;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
        _statusLabel.shadowOffset = CGSizeMake(0, .5);
        [footer addSubview:_statusLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.center = CGPointMake(300, 30);
        [footer addSubview:_activityView];
		
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			_statusLabel.text = kFooterReleaseText;
			break;
		case EGOOPullRefreshNormal:
			_statusLabel.text = kFooterPullText;
			[_activityView stopAnimating];
			break;
		case EGOOPullRefreshLoading:
			_statusLabel.text = kFooterLoadingText;
			[_activityView startAnimating];
			break;
	}
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	if (_state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
	}
    else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && 
            (scrollView.contentOffset.y+scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT && 
            scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT  && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableDidTriggerRefresh:EGORefreshFooter];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}

- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
}

@end