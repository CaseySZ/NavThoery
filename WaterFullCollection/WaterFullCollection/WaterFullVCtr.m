//
//  waterFullVCtr.m
//  WaterFullCollection
//
//  Created by EOC on 2017/3/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "WaterFullVCtr.h"
#import "EocCollectionLayout.h"
#import "ImageCollectCell.h"

@interface WaterFullVCtr ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation WaterFullVCtr{
    NSMutableArray *colorAry;
    EocCollectionLayout *flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    colorAry = [NSMutableArray array];
    
    [colorAry addObject:[UIColor greenColor]];
    [colorAry addObject:[UIColor blueColor]];
    [colorAry addObject:[UIColor whiteColor]];
    [colorAry addObject:[UIColor grayColor]];
    [colorAry addObject:[UIColor lightGrayColor]];
    [colorAry addObject:[UIColor yellowColor]];
    [colorAry addObject:[UIColor orangeColor]];
    [colorAry addObject:[UIColor purpleColor]];
    [colorAry addObject:[UIColor brownColor]];
    [colorAry addObject:[UIColor cyanColor]];
    [colorAry addObject:[UIColor redColor]];
    
    [_colloctionView registerNib:[UINib nibWithNibName:@"ImageCollectCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectCell"];
    
    flowLayout = [[EocCollectionLayout alloc] init];
    [_colloctionView setCollectionViewLayout:flowLayout];
    
    
}

- (IBAction)backEvent:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    
    return [EocCollectionLayout cellCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectCell" forIndexPath:indexPath];
    
    cell.titleLb.text = [@(indexPath.row) description];
    if(cell.frame.size.width > [UIScreen mainScreen].bounds.size.width/3){
        cell.backgroundColor = [colorAry lastObject];
    }else{
        cell.backgroundColor = colorAry[indexPath.row%(colorAry.count-1)];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
