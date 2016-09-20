//
//  MainViewController.m
//  RefreshControl
//
//  Created by yxhe on 16/9/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "MainViewController.h"
#import "RefreshView.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation MainViewController
{
    UITableView *mainTableView;          // 列表
    HeaderView *headerView;          // 下拉刷新组件
    FooterView *footerView;          // 上拉加载组件
    NSMutableArray *tableDataArray;  // 存储列表关联的动态数组
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 列表初始化
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTableView];
    
    // 下拉刷新view
    // 加在负坐标上，因为tableview是scrollview，没关bounce属性的时候是有弹性的
    headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, -50, mainTableView.frame.size.width, 50)];
    [mainTableView addSubview:headerView];
    
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    cell.textLabel.text = @"NibBi";
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
