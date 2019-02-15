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
#import "ImageCompressVC.h"

/*
 https://www.cnblogs.com/fengmin/p/5702240.html
 https://www.jianshu.com/p/e9aa48155c11
 https://www.cnblogs.com/Biaoac/p/5317012.html
 */

/*
 先对比3个概念 UIImage、CImage、CGImage：
 
 UIImage 里面可能包含 CGImage 和 CIImage 数据，是 UIKit 框架的对象。
 CIImage 不是图片，虽然包含了 CGImage 数据，但它只是描述 Core Image filters 处理或产生图片的过程。是 Core Image 框架的对象。Core Image 框架专门处理和分析图片，比如加滤镜效果。
 CGImage 才是图片数据，是 Core Graphics 框架的对象。Core Graphics 框架使用 Quartz 2D 技术进行图片绘制和变换、离屏渲染、图片创建、图层蒙版、创建 PDF 文档等。
 CIImage 和 CGImage 就像菜谱和菜的区别。CIImage 是菜谱，描述如何以及用什么材料做一道菜，而 CGImage 才是可以吃的菜
 
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
        cell.textLabel.text = @"图片文件压缩";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"图片压缩";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"图片处理";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"图片缩放功能";
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"截图";
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"IO";
    }else if (indexPath.row == 6) {
        cell.textLabel.text = @"decode";
    }else if (indexPath.row == 7) {
        cell.textLabel.text = @"code";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewCtr = nil;
    if (indexPath.row == 0) {
        viewCtr = [ImageFileCompressInAlbumVC new];
    }else if (indexPath.row == 1){
        viewCtr = [ImageCompressVC  new];
    }else if (indexPath.row == 2){
        viewCtr = [ImageFilterVC new];
    }else if (indexPath.row == 3){
        viewCtr = [ShotScreenImageVC new];
    }else if (indexPath.row == 4){
        viewCtr = [ImageScaleViewCtr new];
    }else if (indexPath.row == 5){
        viewCtr = [ImageIOBaseVCtr new];
    }else if (indexPath.row == 6){
        viewCtr = [ImageIOViewCtr new];
    }else if (indexPath.row == 7){
        viewCtr = [ImageIOOutViewCtr new];
    }
    [self.navigationController pushViewController:viewCtr animated:YES];
}

@end
