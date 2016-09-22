//
//  MainViewController.m
//  RefreshControl
//
//  Created by yxhe on 16/9/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "MainViewController.h"
#import "RefreshView.h"

// 每个页面的数据数
static const NSInteger kDataCountPerPage = 10;
// 尺寸
#define kCellHeight 80
#define kFooterHeight 60

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation MainViewController
{
    UITableView *mainTableView;      // 主列表（可以使其他种类scrollview）
    HeaderView *headerView;          // 下拉刷新组件
    FooterView *footerView;          // 上拉加载组件
    NSMutableArray *tableImageDataArray;  // 存储列表关联的图片数组
    NSMutableArray *tableTextDataArray; // 存储关联的文字数组
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 列表初始化
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 20)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTableView];
    
    // 下拉刷新view
    // 加在负坐标上，因为tableview是scrollview，没关bounce属性的时候是有弹性的
    headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, -60, mainTableView.frame.size.width, 60)];
    [mainTableView addSubview:headerView];
    
    // 初始化数据
    tableImageDataArray = [[NSMutableArray alloc] init];
    tableTextDataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kDataCountPerPage; i++)
    {
        // 网络图片
        NSURL *url=[NSURL URLWithString:@"http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/00/15/80046_950.jpg"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [tableImageDataArray addObject:image];
        // 随机数字
        NSInteger randNum = arc4random() % 1000;
        [tableTextDataArray addObject:[NSNumber numberWithInteger:randNum]];
    }
    
}

#pragma mark - 上拉和下拉的回调加载
// 刷新
- (void)loadAgain
{
    // 每次只重新加载第一页
    [tableImageDataArray removeAllObjects];
    [tableTextDataArray removeAllObjects];
    // 用占位图片和字符
    UIImage *placeHolderImg = [UIImage imageNamed:@"Img_loading.png"];
    NSInteger placeHolderNum = 888;
    for (int i = 0; i < kDataCountPerPage; i++)
    {
        [tableImageDataArray addObject:placeHolderImg];
        [tableTextDataArray addObject:[NSNumber numberWithInteger:placeHolderNum]];
    }
    // 重新对数据赋值即可，不要清空，否则多线程之间会出现不同步清空，滑动会数组越界
    for (int i = 0; i < kDataCountPerPage; i++)
    {
        // 网络图片
        NSURL *url=[NSURL URLWithString:@"http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/00/15/80046_950.jpg"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        tableImageDataArray[i] = image;
        // 随机数字
        NSInteger randNum = arc4random() % 1000;
        tableTextDataArray[i] = [NSNumber numberWithInteger:randNum];
    }

    // 下面两句都一样
//    [self loadFinished];
    [self performSelectorOnMainThread:@selector(loadFinished) withObject:nil waitUntilDone:NO];

}

// 加载更多
- (void)loadMore
{
    // 加载更多,可以做一些网络请求等后台任务
    for (int i = 0; i < kDataCountPerPage; i++)
    {
        NSURL *url=[NSURL URLWithString:@"http://wenwen.sogou.com/p/20110923/20110923201826-1347223277.jpg"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [tableImageDataArray addObject:image];
        
        // 随机数字
        NSInteger randNum = arc4random() % 1000;
        [tableTextDataArray addObject:[NSNumber numberWithInteger:randNum]];
    }

    // 去主线程刷新UI
    [self performSelectorOnMainThread:@selector(loadFinished) withObject:nil waitUntilDone:NO];
    
}

// 加载完毕，主线程更新UI
- (void)loadFinished
{
    headerView.refreshState = SNormal;
    [mainTableView reloadData];
    
    // 让列表合上去，平滑动画(两种写法)
//    [UIView beginAnimations:nil context:nil];
//    mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.7 animations:^{
        mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
    // 做完事情后恢复
    headerView.refreshState = SNormal;
    footerView.refreshState = SNormal;
    
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableImageDataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 最后一个上拉加载
    if (indexPath.row == tableImageDataArray.count)
    {
        return kFooterHeight;
    }
    // 正常的cell
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    if (indexPath.row != tableImageDataArray.count)
    {
        cell.imageView.image = tableImageDataArray.count ? tableImageDataArray[indexPath.row] : [[UIImage alloc] init];
        cell.textLabel.text = [NSString stringWithFormat:@"cell %ld - %@", indexPath.row, tableTextDataArray[indexPath.row]];
    }
    else
    {
        // 上拉加载
        footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, mainTableView.frame.size.width, 60)];
        cell = footerView;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == tableImageDataArray.count)
    {
        // 点击上拉加载
        footerView.refreshState = SRun;
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
    }
    else
    {
        // 正常cell
        NSLog(@"select %ld cell", indexPath.row);
    }
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 松开之后根据幅度来判断是否下拉刷新或者上拉加载
    if (scrollView.contentOffset.y < -60 && headerView.refreshState == SPullDown)
    {
        
        // 调整边距，防止弹性合上去了，并且用动画平滑
        [UIView beginAnimations:nil context:nil];
        mainTableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        [UIView commitAnimations];
        headerView.refreshState = SRun;
        
        [self performSelectorInBackground:@selector(loadAgain) withObject:nil];
    }
    else if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + kFooterHeight / 2 && footerView.refreshState == SDragUp)
    {
        footerView.refreshState = SRun;
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 其实可以做一些更加精确的事情，比如根据下拉的幅度切换帧动画
    // 下拉
    if (scrollView.contentOffset.y < -60 && headerView.refreshState == SNormal)
    {
        headerView.refreshState = SPullDown;
    }
    else if (scrollView.contentOffset.y > -60 && headerView.refreshState == SPullDown)
    {
        headerView.refreshState = SNormal;
    }
    
    // 上拉
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + kFooterHeight / 2 && footerView.refreshState == SNormal)
    {
        footerView.refreshState = SDragUp;
    }
    else if (scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height + kFooterHeight / 2 && footerView.refreshState == SDragUp)
    {
        footerView.refreshState = SNormal;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
