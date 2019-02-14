//
//  ViewController.m
//  JKUIImageView
//
//  Created by duia on 2019/1/26.
//  Copyright © 2019年 duia. All rights reserved.
//

#import "ViewController.h"

// 1、图片压缩：png、jpg、上下文 三种压缩方式
#import "Test1ViewController.h"
// 2、图片处理：过滤与还原
#import "Test2ViewController.h"
// 3、剪切图片
#import "Test3ViewController.h"
// 4、渲染render与截屏
#import "Test4ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UIImageView高级使用";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.dataArray addObjectsFromArray:@[@"图片压缩",@"图片处理",@"剪切图片",@"渲染render与截屏"]];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、 %@",indexPath.row,self.dataArray[indexPath.row]];
    cell.backgroundColor = JKRandomColor;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+JKstatusBarHeight, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT-44-JKstatusBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            // 小于11.0的不做操作
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    return _tableView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cell_name = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    if ([cell_name isEqualToString:@"图片压缩"]) {
        
        Test1ViewController *test1ViewController = [Test1ViewController new];
        [self.navigationController pushViewController:test1ViewController animated:YES];
    }else if ([cell_name isEqualToString:@"图片处理"]){
        
        Test2ViewController *test2ViewController = [Test2ViewController new];
        [self.navigationController pushViewController:test2ViewController animated:YES];
    }else if ([cell_name isEqualToString:@"剪切图片"]){
        
        Test3ViewController *test3ViewController = [Test3ViewController new];
        [self.navigationController pushViewController:test3ViewController animated:YES];
    }else if ([cell_name isEqualToString:@"渲染render与截屏"]){
        
        Test4ViewController *test4ViewController = [Test4ViewController new];
        [self.navigationController pushViewController:test4ViewController animated:YES];
    }
}

@end
