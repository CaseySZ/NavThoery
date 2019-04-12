//
//  ViewController.m
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SecondViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView *_tableview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableview.estimatedRowHeight = 0;
    _tableview.backgroundColor = [UIColor blueColor];
    _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [self performSelector:@selector(endFresh) withObject:nil afterDelay:5];
        
    }];
    
    
    _tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        [self performSelector:@selector(endFresh) withObject:nil afterDelay:5];
        
    }];
    
    _tableview.mj_header.backgroundColor = UIColor.redColor;
    _tableview.mj_footer.backgroundColor = UIColor.yellowColor;
}


- (void)endFresh{
    
    [_tableview.mj_header endRefreshing];
    [_tableview.mj_footer endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [@(indexPath.row) description];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
    
    
}

- (void)dealloc{
    
    NSLog(@"Second delloc");
}

@end
