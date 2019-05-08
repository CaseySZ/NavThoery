//
//  ViewController.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ViewController.h"
#import "BaseInfoViewCtr.h"
#import "ContentViewCtr.h"
#import "DemoContentsViewCtr.h"
#import "GeometryViewCtr.h"
#import "ChangeViewCtr.h"
#import "TDChangeViewCtr.h"
#import "TDDemoViewCtr.h"
#import "AnimationViewCtr.h"
#import "AnimationGroupViewCtr.h"
#import "TransitionViewCtr.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *_titleArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    _titleArr = @[@"Base", @"寄宿图", @"Demo", @"Geometry", @"transform", @"3D", @"3DDome", @"Animation", @"Group", @"Transition"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [self.navigationController pushViewController:[BaseInfoViewCtr new] animated:YES];
        
    }else if (indexPath.row == 1) {
        
        [self.navigationController pushViewController:[ContentViewCtr new] animated:YES];
    }else if (indexPath.row == 2) {
        
        [self.navigationController pushViewController:[DemoContentsViewCtr new] animated:YES];
    }else if (indexPath.row == 3) {
        
        [self.navigationController pushViewController:[GeometryViewCtr new] animated:YES];
    }else if (indexPath.row == 4) {
        
        [self.navigationController pushViewController:[ChangeViewCtr new] animated:YES];
    }else if (indexPath.row == 5) {
        
        [self.navigationController pushViewController:[TDChangeViewCtr new] animated:YES];
        
    }else if (indexPath.row == 6) {
        
        [self.navigationController pushViewController:[TDDemoViewCtr new] animated:YES];
        
    }else if (indexPath.row == 7) {
        
        [self.navigationController pushViewController:[AnimationViewCtr new] animated:YES];
        
    }else if (indexPath.row == 8) {
        
        [self.navigationController pushViewController:[AnimationGroupViewCtr new] animated:YES];
        
    }else if (indexPath.row == 9) {
        
        [self.navigationController pushViewController:[TransitionViewCtr new] animated:YES];
        
    }else {
        
     
        
    }
}



@end
