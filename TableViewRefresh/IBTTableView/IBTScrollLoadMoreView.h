//
//  IBTScrollLoadMoreView.h
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadMoreState) {
    kLoadStateNormal = 1,
    kLoadStateDraging,
    kLoadStateLoading,
    kLoadStateFinished,
    kLoadStateFailed,
    kLoadStateNoMore,
};

@interface IBTScrollLoadMoreView : UIView

@property (nonatomic, assign, readonly) LoadMoreState currentState;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *loadMoreText;
@property (nonatomic, strong) NSString *dragToLoadText;
@property (nonatomic, strong) NSString *loadingText;
@property (nonatomic, strong) NSString *finishedText;
@property (nonatomic, strong) NSString *failedText;
@property (nonatomic, strong) NSString *noMoreText;

- (void)updateState:(LoadMoreState)state;

@end
