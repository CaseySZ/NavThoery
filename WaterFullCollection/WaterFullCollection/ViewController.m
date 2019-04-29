//
//  ViewController.m
//  WaterFullCollection
//
//  Created by EOC on 2017/3/24.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectCell.h"
#import "EocCollectionLayout.h"
#import "SimpleCollectionVCtr.h"
#import "WaterFullVCtr.h"



// http://image88.360doc.com/DownloadImg/2015/09/0408/58557220_2.jpg   58;
@interface ViewController (){

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
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
        cell.textLabel.text = @"简单使用CollectionView";
    }else{
        cell.textLabel.text = @"瀑布流";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        SimpleCollectionVCtr *simpCollectV = [[SimpleCollectionVCtr alloc] init];
        [self presentViewController:simpCollectV animated:YES completion:nil];
    }else{
        WaterFullVCtr *waterFullVCtr = [[WaterFullVCtr alloc] init];
        [self presentViewController:waterFullVCtr animated:YES completion:nil];
    }
}

@end
