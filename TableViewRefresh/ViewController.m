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
    
    self.dataArray = [self arrayWithCount:20];
    
    [self setupSubviews];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        [_tableView tableViewDidReachFootView];
    }
}

#pragma mark - TableViewRefreshDelegate

-(void)startRefreshData:(UIScrollView *)scrollView {
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
}

-(void)endRefreshData:(UIScrollView *)scrollView {
    
}

-(void)startLoadMoreData:(UIScrollView *)scrollView {
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:1];
}

-(void)endLoadMoreData:(UIScrollView *)scrollView {
    
}


@end
