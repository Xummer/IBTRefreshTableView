//
//  IBTTableView.m
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import "IBTTableView.h"

@interface IBTTableView ()

@property (strong, nonatomic) UIView *refreshFooterView;

@end

@implementation IBTTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        //        [self registerForFooterKVO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self registerForFooterKVO];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self registerForFooterKVO];
}

- (void)dealloc {
//    [self unregisterFromFooterKVO];
}

- (void)setRefreshFooterView:(UIView *)refreshFooterView {

    if (_refreshFooterView != refreshFooterView) {
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = refreshFooterView;
        [self addSubview:refreshFooterView];
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_refreshFooterView) {
        CGRect frame = _refreshFooterView.frame;
        frame.origin.y = self.contentSize.height;
        _refreshFooterView.frame = frame;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.window endEditing:YES];
}

- (void)reloadData {
    [super reloadData];
    CGRect bounds = self.bounds;
    CGSize size = self.contentSize;
    UIEdgeInsets inset = self.contentInset;
    if (size.height < bounds.size.height - inset.bottom ||
        [self.dataSource tableView:self numberOfRowsInSection:0] == 0) {
        self.refreshFooterView = nil;
    }
    else {
        self.refreshFooterView = _loadMoreView;
    }
}

- (void)scrollToTopAnimated:(BOOL)animated {
    if ([super numberOfSections] > 0) {
        if ([super numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [super scrollToRowAtIndexPath:indexP
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:animated];
        }
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger lastSection = [super numberOfSections];
    if (lastSection > 0) {
        lastSection -= 1;
    }
    else {
        return;
    }
    
    NSInteger lastRow = [super numberOfRowsInSection:lastSection];
    if (lastRow > 0) {
        lastRow -= 1;
    }
    else {
        return;
    }
    
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    
    [super scrollToRowAtIndexPath:indexP
                 atScrollPosition:UITableViewScrollPositionBottom
                         animated:animated];
}

- (void)addRefreshControlWithText:(NSString *)text {
    if (!_refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self
                            action:@selector(handleRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    }
    
    if (text.length > 0) {
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:text];
    }
    
    if (!_refreshControl.superview) {
        [self addSubview:_refreshControl];
    }
}

- (void)removeRefreshControl {
    if (_refreshControl && _refreshControl.superview) {
        [_refreshControl removeFromSuperview];
    }
}

- (void)handleRefresh:(id)sender {
    //    UIRefreshControl *refreshControl = (UIRefreshControl *)sender;
    if ([_refreshDelegate respondsToSelector:@selector(startRefreshData:)]) {
        // Do networking in |startRefreshData:|
        [_refreshDelegate startRefreshData:self];
    }
    
    //    [self performSelector:@selector(endRefresh:) withObject:refreshControl afterDelay:1.0f];
}

- (void)endRefresh:(id)sender {
    if ([_refreshDelegate respondsToSelector:@selector(endRefreshData:)]) {
        [_refreshDelegate endRefreshData:self];
    }
    
    [self endRefreshWithState:kRefreshStateFailed];
}

- (void)endRefreshWithState:(RefreshState)state {
    //    NSString *textStr;
    //    switch (state) {
    //        case kLoadStateFinished:
    //            textStr = @"刷新成功";
    //            break;
    //        case kLoadStateFailed:
    //            textStr = @"刷新失败";
    //            break;
    //        case kRefreshStateTimeOut
    //            textStr = @"连接超时";
    //            break;
    //        default:
    //            break;
    //    }
    //
    //    if (textStr.length > 0) {
    //        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:textStr];
    //    }
    
    if (_refreshControl.refreshing) {
        [_refreshControl endRefreshing];
    }
}

- (void)addLoadMoreFootWithText:(NSString *)text {
    if (!_loadMoreView) {
        CGRect frame = (CGRect){
            .origin.x = 0,
            .origin.y = 0,
            .size.width = CGRectGetWidth(self.bounds),
            .size.height = 44
        };
        self.loadMoreView = [[IBTScrollLoadMoreView alloc] initWithFrame:frame];
        _loadMoreView.textColor = [UIColor grayColor];
        
        _loadMoreView.loadMoreText = text;
    }
    
    self.refreshFooterView = _loadMoreView;
    [_loadMoreView updateState:kLoadStateNormal];
}

- (void)removeLoadMoreFoot {
    if (self.refreshFooterView == _loadMoreView) {
        self.refreshFooterView = nil;
    }
}

- (void)startLoadMore {
    if (_loadMoreView.currentState != kLoadStateLoading &&
        _loadMoreView.currentState != kLoadStateNoMore)
    {
        if ([_refreshDelegate respondsToSelector:@selector(startLoadMoreData:)]) {
            [_refreshDelegate startLoadMoreData:self];
        }
        //        [self performSelector:@selector(endLoadWithFailed)
        //                   withObject:nil
        //                   afterDelay:1];
        [_loadMoreView updateState:kLoadStateLoading];
    }
}

- (void)endLoadMoreWithState:(LoadMoreState)state {
    if (self.refreshFooterView) {
        [_loadMoreView updateState:state];
        
        if ([_refreshDelegate respondsToSelector:@selector(endLoadMoreData:)]) {
            [_refreshDelegate endLoadMoreData:self];
        }
        
        [UIView animateWithDuration:.2f animations:^{
            self.contentInset = UIEdgeInsetsZero;
        }];
    }
}

- (void)resetLoadMoreFoot {
    [self endLoadMoreWithState:kLoadStateNormal];
}

- (void)endLoadWithFailed {
    [self endLoadMoreWithState:kLoadStateFailed];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_refreshFooterView) {
        return;
    }
    if (_loadMoreView.currentState == kLoadStateLoading) {
        CGFloat offsetH = CGRectGetHeight(_loadMoreView.frame);
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, offsetH, 0);
    }
    else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
		if ([_refreshDelegate respondsToSelector:@selector(isFooterLoading)]) {
			_loading = [_refreshDelegate isFooterLoading];
		}
        
        CGFloat maxOffsetY = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame);
        
        NSLog(@" %f - %f", scrollView.contentOffset.y, maxOffsetY );
        
        if (_loadMoreView.currentState == kLoadStateDraging &&
            scrollView.contentOffset.y > maxOffsetY &&
            scrollView.contentOffset.y < maxOffsetY + CGRectGetHeight(_loadMoreView.frame) &&
            !_loading)
        {
			[_loadMoreView updateState:kLoadStateNormal];
		}
        else if ((_loadMoreView.currentState == kLoadStateNormal ||
                 _loadMoreView.currentState >= kLoadStateFinished) &&
                 scrollView.contentOffset.y > maxOffsetY + CGRectGetHeight(_loadMoreView.frame) &&
                 !_loading)
        {
			[_loadMoreView updateState:kLoadStateDraging];
		}
        
        if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
}

- (void)tableviewDidEndDragging:(UIScrollView *)scrollView {
    BOOL _loading = NO;
	if ([_refreshDelegate respondsToSelector:@selector(isFooterLoading)]) {
        _loading = [_refreshDelegate isFooterLoading];
    }
	
    CGFloat maxOffsetY = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame);
	if (scrollView.contentOffset.y >= maxOffsetY + CGRectGetHeight(_loadMoreView.frame) &&
        !_loading) {
		
		if ([_refreshDelegate respondsToSelector:@selector(startLoadMoreData:)]) {
            [_refreshDelegate startLoadMoreData:self];
        }
		
		[_loadMoreView updateState:kLoadStateLoading];
        
        [UIView animateWithDuration:.2f animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(_loadMoreView.frame), 0);
        }];
	}
}

- (void)resetFooterView {
    if (_refreshFooterView) {
        CGFloat contentHeight = self.contentSize.height;
        CGRect frame = _refreshFooterView.frame;
        frame.origin = (CGPoint){
            .x = (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) * .5f,
            .y = contentHeight,
        };
        _refreshFooterView.frame = frame;

        if (_refreshFooterView.superview != self) {
            [self addSubview:_refreshFooterView];
        }
    }
}

#pragma mark - KVO
- (void)registerForFooterKVO {
    for (NSString *keyPath in [self observableKeypathsOfHeadView]) {
		[self addObserver:self
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
	}
}

- (void)unregisterFromFooterKVO {
    for (NSString *keyPath in [self observableKeypathsOfHeadView]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypathsOfHeadView {
    return @[ @"contentSize" ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self resetFooterView];
    }
    
}


@end
