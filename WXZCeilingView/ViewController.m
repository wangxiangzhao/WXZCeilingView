//
//  ViewController.m
//  WXZCeilingView
//
//  Created by 王向召 on 2019/7/12.
//  Copyright © 2019 王向召. All rights reserved.
//

#import "ViewController.h"
#import "WXZCeilingView.h"

static NSString * const kIdentifiter = @"indentifiter";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WXZCeilingView *ceilingView;

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 30.;
    [_tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:kIdentifiter];
    
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    
    //吸顶控件
    UIView *ceilingBar = [[UIView alloc] init];
    ceilingBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    ceilingBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40);
    
    CGSize buttonSize = CGSizeMake(CGRectGetWidth(ceilingBar.frame) / 3, CGRectGetHeight(ceilingBar.frame));
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * buttonSize.width, 0, buttonSize.width, buttonSize.height);
        [button setTitle:[NSString stringWithFormat:@"section%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ceilingBar addSubview:button];
    }
    
    //导航栏高度
    CGFloat barHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    self.ceilingView = [WXZCeilingView viewWithFrame:CGRectMake(0, barHeight, self.view.frame.size.width, self.view.frame.size.height - barHeight) bodyView:_tableView headerView:headerView ceilingBar:ceilingBar];
    [self.view addSubview:self.ceilingView];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifiter forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd --- %zd", indexPath.row, indexPath.section];
    return cell;
}

#pragma mark - actions

- (void)buttonClick:(UIButton *)button {
    [_ceilingView ceilingTop];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:button.tag] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

@end
