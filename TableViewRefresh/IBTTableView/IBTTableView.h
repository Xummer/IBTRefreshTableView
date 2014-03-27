//
//  IBTTableView.h
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBTScrollLoadMoreView.h"
#import "IBTScrollViewRefreshDelegate.h"

@interface IBTTableView : UITableView

@property (assign, nonatomic) id <IBTScrollViewRefreshDelegate> refreshDelegate;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBTScrollLoadMoreView *loadMoreView;

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)addRefreshControlWithText:(NSString *)text;
- (void)removeRefreshControl;
- (void)endRefreshWithState:(RefreshState)state;

- (void)addLoadMoreFootWithText:(NSString *)text;
- (void)removeLoadMoreFoot;
- (void)startLoadMore;
- (void)endLoadMoreWithState:(LoadMoreState)state;
- (void)resetLoadMoreFoot;

// call |tableViewDidScroll:| in delegate Method |scrollViewDidScroll:|
- (void)tableViewDidScroll:(UIScrollView *)scrollView;

// call |tableviewDidEndDragging:| in delegate Method |scrollViewDidEndDragging:|
- (void)tableviewDidEndDragging:(UIScrollView *)scrollView;

@end
