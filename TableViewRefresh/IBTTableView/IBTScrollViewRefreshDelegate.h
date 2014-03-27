//
//  IBTScrollViewRefreshDelegate.h
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RefreshState) {
    kRefreshStateFinished,
    kRefreshStateFailed,
    kRefreshStateTimeOut,
};

@protocol IBTScrollViewRefreshDelegate <NSObject>

@optional
// Top refresh
-(void)startRefreshData:(UIScrollView *)scrollView;
-(void)endRefreshData:(UIScrollView *)scrollView;

// Bottom loadMore
-(void)startLoadMoreData:(UIScrollView *)scrollView;
-(void)endLoadMoreData:(UIScrollView *)scrollView;

@end
