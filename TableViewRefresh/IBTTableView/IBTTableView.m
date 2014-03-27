//
//  IBTTableView.m
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import "IBTTableView.h"

@interface IBTTableView ()



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
        // Initialization code
        //        [self registerForFooterKVO];
        
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self registerForFooterKVO];
//}
//
//- (void)dealloc {
//    [self unregisterFromFooterKVO];
//}

//- (void)setRefreshFooterView:(UIView *)refreshFooterView {
//
//    if (_refreshFooterView != refreshFooterView) {
//        [_refreshFooterView removeFromSuperview];
//        _refreshFooterView = refreshFooterView;
//    }
//
//}

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
        self.tableFooterView = nil;
    }
    else {
        self.tableFooterView = _loadMoreView;
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
    
    self.tableFooterView = _loadMoreView;
    [_loadMoreView updateState:kLoadStateDefault];
}

- (void)removeLoadMoreFoot {
    if (self.tableFooterView == _loadMoreView) {
        self.tableFooterView = nil;
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
    if (self.tableFooterView) {
        [_loadMoreView updateState:state];
    }
}

- (void)resetLoadMoreFoot {
    if (self.tableFooterView) {
        [_loadMoreView updateState:kLoadStateDefault];
    }
}

- (void)endLoadWithFailed {
    if (self.tableFooterView) {
        [_loadMoreView updateState:kLoadStateFailed];
    }
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableFooterView) {
        
        CGPoint offset = self.contentOffset;
        CGRect bounds = self.bounds;
        CGSize size = self.contentSize;
        UIEdgeInsets inset = self.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        float reload_distance = CGRectGetHeight(self.tableFooterView.frame);
        if(y > h - reload_distance) {
            [self startLoadMore];
            //            NSLog(@"load more rows");
        }
    }
}

//- (void)resetFooterView {
//    if (_refreshFooterView) {
//        CGFloat contentHeight = self.contentSize.height;
//        CGRect frame = _refreshFooterView.frame;
//        frame.origin = (CGPoint){
//            .x = (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) * .5f,
//            .y = contentHeight,
//        };
//        _refreshFooterView.frame = frame;
//
//        if (_refreshFooterView.superview != self) {
//            [self addSubview:_refreshFooterView];
//        }
//    }
//}

//#pragma mark - KVO
//- (void)registerForFooterKVO {
//    for (NSString *keyPath in [self observableKeypathsOfHeadView]) {
//		[self addObserver:self
//               forKeyPath:keyPath
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];
//	}
//}
//
//- (void)unregisterFromFooterKVO {
//    for (NSString *keyPath in [self observableKeypathsOfHeadView]) {
//		[self removeObserver:self forKeyPath:keyPath];
//	}
//}
//
//- (NSArray *)observableKeypathsOfHeadView {
//    return @[ @"contentSize" ];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        [self resetFooterView];
//    }
//    
//}


@end
