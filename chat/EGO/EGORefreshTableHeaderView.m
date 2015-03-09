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
#import "EGOViewCommon.h"

#define kContentOffsetKey   @"contentOffset"

@interface EGORefreshTableHeaderView ( )
{
    
    __unsafe_unretained id _delegate;
    EGOPullRefreshState _state;
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    
    // dql
    CADisplayLink * _displayLink;
    __weak UIScrollView * _superView;
}
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        float width = [UIScreen mainScreen].bounds.size.width;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.5 - 10.0f, frame.size.height - 25.0f, self.frame.size.width * 0.5, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:9.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		_lastUpdatedLabel = label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.5 - 10.0f, frame.size.height - 42.0f, self.frame.size.width * 0.5, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		_statusLabel = label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(width * 0.5 - 35.0f, frame.size.height - 38.0f, 15.0f, 23.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage = layer;
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"pulldown_half_img" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
    NSDate * date = [NSDate date];
		
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";

    _lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新 %@", [dateFormatter stringFromDate:date]];
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState)
    {
		case EGOOPullRefreshPulling: // 松开立即刷新
        {
            _statusLabel.text = @"释放刷新";
            _arrowImage.contents = (id)[UIImage imageNamed:@"pulldown_end_img"].CGImage;
            
            break;
        }

		case EGOOPullRefreshNormal: // 下拉可以刷新
        {
//            if (_state == EGOOPullRefreshPulling) {
//            if (_state == EGOOPullRefreshLoading) {
//                [CATransaction begin];
//                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//                _arrowImage.contents = (id)[UIImage imageNamed:@"pulldown_half_img"].CGImage;
//                [CATransaction commit];
//            }
    
            _statusLabel.text = @"下拉刷新";
            if (_displayLink) {
                [_displayLink invalidate];
                _displayLink = nil;
            }
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.contents = (id)[UIImage imageNamed:@"pulldown_half_img"].CGImage;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        }

		case EGOOPullRefreshLoading: // 刷新中
        {

            _statusLabel.text = @"加载中...";
            CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
            _displayLink = displayLink;
            displayLink.frameInterval = 8;
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            _arrowImage.contents = (id)[UIImage imageNamed:@"refresh_one_img"].CGImage;
            
            break;
        }
        default:
			break;
	}
	
	_state = aState;
}

- (void)step
{
    static int s = 0;
    
    if (s == 0) {
        _arrowImage.contents = (id)[UIImage imageNamed:@"refresh_two_img"].CGImage;
    }
    else if (s == 1) {
        _arrowImage.contents = (id)[UIImage imageNamed:@"refresh_three_img"].CGImage;
    }
    else if (s == 2) {
        _arrowImage.contents = (id)[UIImage imageNamed:@"refresh_one_img"].CGImage;
        s = -1;
    }

    s++;
}


#pragma mark -
#pragma mark ScrollView Methods
/*
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	

	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    //NSLog(@"egoRefreshScrollViewDidEndDragging scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
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
*/

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


// dql
- (void)beginRefresh
{
    [UIView animateWithDuration:0.5f animations:^{
        _superView.contentInset = UIEdgeInsetsMake(kRefreshViewHeight, 0, 0, 0);
        _superView.contentOffset = CGPointMake(0, -kRefreshViewHeight);
    } completion:^(BOOL finished) {
        [self setState:EGOOPullRefreshPulling];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setState:EGOOPullRefreshLoading];
            
            if ([_delegate respondsToSelector:@selector(egoRefreshTableView:DidTriggerRefresh:)]) {
                [_delegate egoRefreshTableView:self DidTriggerRefresh:EGORefreshHeader];
            }
        });

    }];
}

- (void)endRefresh
{
    [self setState:EGOOPullRefreshNormal];
    
    [UIView animateWithDuration:0.3f animations:^{
        _superView.contentOffset = CGPointMake(0, 0);
        _superView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];

}

// 利用 KVO 监控父类的 contentOffset 属性的变化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:kContentOffsetKey];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:kContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
        
        _superView = (UIScrollView *)newSuperview;
    }
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (_state == EGOOPullRefreshLoading) return;
    
    if ([kContentOffsetKey isEqualToString:keyPath]) {
        // 向上滚动到看不见头控件，直接返回
        if (_superView.contentOffset.y > kRefreshViewHeight) return;
        
        if (_superView.isDragging) {
            // 松开刷新
            if (_state == EGOOPullRefreshNormal && _superView.contentOffset.y < -kRefreshViewHeight) {
                [self setState:EGOOPullRefreshPulling];
            }
            // 拉到一半后，不松开而是往上推
            else if (_state == EGOOPullRefreshPulling && _superView.contentOffset.y > -kRefreshViewHeight && _superView.contentOffset.y < 0.0f) {
                [self setState:EGOOPullRefreshNormal];
            }
        }
        // 刷新
        else if (_state == EGOOPullRefreshPulling) {
            
            [self setState:EGOOPullRefreshLoading];
            if ([_delegate respondsToSelector:@selector(egoRefreshTableView:DidTriggerRefresh:)]) {
                [_delegate egoRefreshTableView:self DidTriggerRefresh:EGORefreshHeader];
            }
            [UIView animateWithDuration:0.3f animations:^{
                _superView.contentOffset = CGPointMake(0, -kRefreshViewHeight);
                _superView.contentInset = UIEdgeInsetsMake(kRefreshViewHeight, 0, 0, 0);
            }];
        }
        
    }
}

@end
