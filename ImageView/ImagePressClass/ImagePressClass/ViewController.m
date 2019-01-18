//
//  ViewController.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ViewController.h"
#import "ImageFileCompressInAlbumVC.h"
#import "ImageFilterVC.h"
#import "ImageScaleViewCtr.h"
#import "ShotScreenImageVC.h"
#import "ImageIOViewCtr.h"
#import "ImageIOOutViewCtr.h"
#import "ImageIOBaseVCtr.h"

/*
 https://www.cnblogs.com/fengmin/p/5702240.html
 */

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"相册图片压缩";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"图片处理";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"图片缩放功能";
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"截图";
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"IO";
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"decode";
    }else if (indexPath.row == 6) {
        cell.textLabel.text = @"code";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewCtr = nil;
    if (indexPath.row == 0) {
        viewCtr = [ImageFileCompressInAlbumVC new];
    }else if (indexPath.row == 1){
        viewCtr = [ImageFilterVC new];
    }else if (indexPath.row == 2){
        viewCtr = [ShotScreenImageVC new];
    }else if (indexPath.row == 3){
        viewCtr = [ImageScaleViewCtr new];
    }else if (indexPath.row == 4){
        viewCtr = [ImageIOBaseVCtr new];
    }else if (indexPath.row == 5){
        viewCtr = [ImageIOViewCtr new];
    }else if (indexPath.row == 6){
        viewCtr = [ImageIOOutViewCtr new];
    }
    [self.navigationController pushViewController:viewCtr animated:YES];
}

@end
