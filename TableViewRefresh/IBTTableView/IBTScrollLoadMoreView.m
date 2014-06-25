//
//  IBTScrollLoadMoreView.m
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import "IBTScrollLoadMoreView.h"

@interface IBTScrollLoadMoreView ()

@property (nonatomic, strong) UILabel *loadMoreLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation IBTScrollLoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self setupDefualtText];
    
    self.loadMoreLabel = [[UILabel alloc] init];
    _loadMoreLabel.backgroundColor = [UIColor clearColor];
    _loadMoreLabel.textAlignment = NSTextAlignmentCenter;
    _loadMoreLabel.font = [UIFont systemFontOfSize:14];
    _loadMoreLabel.textColor = [UIColor grayColor];
    _loadMoreLabel.text = _loadMoreText;
    
    [self addSubview:_loadMoreLabel];
    
    self.indicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicator];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectInset(self.bounds, 20, 7);
    _loadMoreLabel.frame = frame;
    
    frame = _indicator.frame;
    frame.origin =
    CGPointMake(50, (CGRectGetHeight(self.bounds) - CGRectGetHeight(_indicator.frame))*.5f );
    _indicator.frame = frame;
    
}

- (void)setupDefualtText {
    self.loadMoreText = @"Load more";
    self.dragToLoadText = @"Pull up to load more";
    self.loadingText = @"Loading...";
    self.finishedText = @"Load finished";
    self.failedText = @"Load failed";
    self.noMoreText = @"No more";
}

- (void)updateState:(LoadMoreState)state {
    if (state == _currentState) {
        return;
    }
    NSString *textStr;
    BOOL needAnimate = NO;
    switch (state) {
        case kLoadStateNormal:
            textStr = _loadMoreText;
            break;
        case kLoadStateDraging:
            textStr = _dragToLoadText;
            break;
        case kLoadStateLoading:
            needAnimate = YES;
            textStr = _loadingText;
            break;
        case kLoadStateFinished:
            textStr = _finishedText;
            break;
        case kLoadStateFailed:
            textStr = _failedText;
            break;
        case kLoadStateNoMore:
            textStr = _noMoreText;
            break;
        default:
            break;
    }
    
    _loadMoreLabel.text = textStr;
    if (needAnimate) {
        if (![_indicator isAnimating]) {
            [_indicator startAnimating];
        }
    }
    else {
        if ([_indicator isAnimating]) {
            [_indicator stopAnimating];
        }
    }
    
    _currentState = state;
    
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _loadMoreLabel.textColor = textColor;
}

- (void)setLoadMoreText:(NSString *)loadMoreText {
    _loadMoreText = loadMoreText;
    _loadMoreLabel.text = loadMoreText;
}


@end
