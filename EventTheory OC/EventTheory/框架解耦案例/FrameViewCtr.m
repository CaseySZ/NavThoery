//
//  FrameViewCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/23.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "FrameViewCtr.h"
#import "TableHeadView.h"

@interface FrameViewCtr (){
    
    IBOutlet UITableView *_tableview;
}

@end

@implementation FrameViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    TableHeadView *headView = [TableHeadView instance];
    [_tableview setTableHeaderView:headView];
    
    
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [@(indexPath.row) description];
    return cell;
}


@end
