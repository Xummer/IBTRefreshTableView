#IBTRefreshTableView

整合系统的下拉刷新和自定义的（参考[EGOTableViewPullRefresh](https://github.com/enormego/EGOTableViewPullRefresh)）的上拉加载更多，到`UITableView`。

支持iOS6及以上。

## How

1、 添加Protocol  

```
@interface ViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    IBTScrollViewRefreshDelegate
>
@end
```
2、 设置Delegate，并选择性添加下拉刷新和上拉加载更多

```
_tableView.refreshDelegate = self;

[_tableView addRefreshControlWithText:@""];
[_tableView addLoadMoreFootWithText:@"LoadMore"];
```

3、 实现`UIScrollViewDelegate`

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        [_tableView tableViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == _tableView) {
        [_tableView tableviewDidEndDragging:scrollView];
    }
}
```  

4、实现`IBTScrollViewRefreshDelegate`

```
-(void)startRefreshData:(UIScrollView *)scrollView {
    
    // refresh data
    
    [_tableView reloadData];
    [_tableView endRefreshWithState:kRefreshStateFinished];
}

-(void)endRefreshData:(UIScrollView *)scrollView {
    
}

-(void)startLoadMoreData:(UIScrollView *)scrollView {
    
    // update data
    
    [_tableView reloadData];
    [_tableView endLoadMoreWithState:kLoadStateFinished];
}

-(void)endLoadMoreData:(UIScrollView *)scrollView {
    
}
```