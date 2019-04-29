//
//  SimpleCollectionVCtr.m
//  WaterFullCollection
//
//  Created by EOC on 2017/3/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "SimpleCollectionVCtr.h"
#import "ImageCollectCell.h"
#import "EocCollectionLayout.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define CollectionHeadHeight 40

@interface SimpleCollectionVCtr ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>{
    NSMutableArray *colorAry;
    IBOutlet UICollectionView *_colloctionView;
}

@end

@implementation SimpleCollectionVCtr

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
    [self baseConfigDateCollectView];
}

- (IBAction)backEvent:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)baseConfigDateCollectView{
    /* collectionView 用UICollectionViewFlowLayout对象布局
      ⚠️ 也可以用代理布局， 优点：使用简单，布局风格单一； 缺陷：做了不复杂化的布局
     */
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.itemSize = CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7);
    flowlayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, CollectionHeadHeight);
    [_colloctionView setCollectionViewLayout:flowlayout];
    
}

/* 代理模式FlowLayout  
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(123, 123);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
*/

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


@end
