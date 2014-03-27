//
//  ViewController.m
//  TableViewRefresh
//
//  Created by Xummer on 14-3-27.
//  Copyright (c) 2014年 Xummer. All rights reserved.
//

#import "ViewController.h"
#import "IBTTableView.h"

static NSString *cellID = @"CellReuseIdentifier";

@interface ViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    IBTScrollViewRefreshDelegate
>
{
    NSInteger _arrcount;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet IBTTableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrcount = 26
    self.dataArray = [self arrayWithCount:_arrcount];
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.refreshDelegate = self;
    
    [_tableView addRefreshControlWithText:@""];
    [_tableView addLoadMoreFootWithText:@"LoadMore"];
    
}

- (NSArray *)arrayWithCount:(NSUInteger)count {
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i ++) {
        [mArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    return mArr;
}

- (void)endRefresh {
    [_tableView endRefreshWithState:kRefreshStateFinished];
}

- (void)endLoadMore {
    [_tableView endLoadMoreWithState:kLoadStateFinished];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellID
                                    forIndexPath:indexPath];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

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

#pragma mark - IBTScrollViewRefreshDelegate

-(void)startRefreshData:(UIScrollView *)scrollView {
    _arrcount = 26;
    self.dataArray = [self arrayWithCount:_arrcount];
    [_tableView reloadData];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
}

-(void)endRefreshData:(UIScrollView *)scrollView {
    
}

-(void)startLoadMoreData:(UIScrollView *)scrollView {
    _reloading = YES;
    _arrcount += 10;
    self.dataArray = [self arrayWithCount:_arrcount];
    [_tableView reloadData];
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:1];
}

-(void)endLoadMoreData:(UIScrollView *)scrollView {
    _reloading = NO;
}

- (BOOL)isFooterLoading {
    return _reloading;
}


@end
