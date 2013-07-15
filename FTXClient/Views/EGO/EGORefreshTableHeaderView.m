//
//  EGORefreshTableHeaderView.m
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

#import "EGORefreshTableHeaderView.h"
#import "UIColor+FTX.h"

#define kHeaderPullText @"下拉刷新"
#define kHeaderLoadingText @"努力加载中..."
#define kHeaderReleaseText @"释放加载最新内容"

#define REFRESH_HEADER_HEIGHT 60

@interface EGORefreshTableHeaderView ()
{
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation EGORefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - REFRESH_HEADER_HEIGHT, CGRectGetWidth(frame), REFRESH_HEADER_HEIGHT)];
        header.backgroundColor = [UIColor blackColor];
        [self addSubview:header];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh-logo"]];
        logo.center = CGPointMake(35, REFRESH_HEADER_HEIGHT/2.0);
        [header addSubview:logo];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, 100, 46)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.text = kHeaderPullText;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
        _statusLabel.shadowOffset = CGSizeMake(0, .5);
        [header addSubview:_statusLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.center = CGPointMake(300, 30);
        [header addSubview:_activityView];
		
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
}

- (void)setState:(EGOPullRefreshState)aState{
	switch (aState) {
		case EGOOPullRefreshPulling:
			_statusLabel.text = kHeaderReleaseText;
			break;
		case EGOOPullRefreshNormal:
			_statusLabel.text = kHeaderPullText;
			[_activityView stopAnimating];
			break;
		case EGOOPullRefreshLoading:
			_statusLabel.text = kHeaderLoadingText;
			[_activityView startAnimating];
			break;
	}
	_state = aState;
}


#pragma mark - ScrollView Methods
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	}
    else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
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
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableDidTriggerRefresh:EGORefreshHeader];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
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
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
}

@end