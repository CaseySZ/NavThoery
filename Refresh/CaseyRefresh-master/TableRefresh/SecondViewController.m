//
//  SecondViewController.m
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "SecondViewController.h"
#import "CaseyRefresh.h"
#import "AliRefreshHeaderView.h"


@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView *_tableview;
    CyRefreshHeaderDefaultView *headview;
    CyRefreshFooterDefaultView *footerview;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableview.estimatedRowHeight = 0;
    __weak typeof(self) weakSelf = self;
    
    headview = [AliRefreshHeaderView headerWithRefreshingBlock:^{
        
        NSLog(@"refresh ing");
        [weakSelf performSelector:@selector(endFresh) withObject:nil afterDelay:5];
        
        
    }];
    _tableview.cy_header =headview;
    
   
    
    footerview= [CyRefreshFooterDefaultView footerWithRefreshingBlock:^{
        
        NSLog(@"footer refresh ing");
        [weakSelf performSelector:@selector(endFresh) withObject:nil afterDelay:5];
        
    }];
    _tableview.cy_footer = footerview;
    
    _tableview.cy_footer.backgroundColor = UIColor.yellowColor;
    
}

- (void)endFresh{
    
        [_tableview.cy_header endRefreshing];
        [_tableview.cy_footer endRefreshingNoMoreData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 15;
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
    
    NSLog(@"%s", __func__);
}

@end
