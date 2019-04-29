//
//  EocCollectionLayout.m
//  WaterFullCollection
//
//  Created by EOC on 2017/3/24.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EocCollectionLayout.h"
#import "WaterFullCollectCellModel.h"

// http://image88.360doc.com/DownloadImg/2015/09/0408/58557220_2.jpg   58;

static const int __ImageCount = 58;


@implementation EocCollectionLayout


- (instancetype)init{
    
    self = [super init];
    if (self) {
        _colomnRowVCount = 3;
        _colomnRowAddUpHeightAry = [NSMutableArray array];
        _layoutAtrAry = [NSMutableArray array];
        for (int i = 0; i < _colomnRowVCount; i++) {
            [_colomnRowAddUpHeightAry addObject:@(0)];
        }
    }
    return self;
    
}

+ (NSInteger)cellCount{
    
    return __ImageCount;
}

- (void)setColomnRowVCount:(NSInteger)count{
    
    _colomnRowVCount = count;
    
}

//1. 为layout做准备工作，属性设置
- (void)prepareLayout{
    NSLog(@"%s", __func__);
    [super prepareLayout];
    [_colomnHeightAry removeAllObjects];
    for (int i = 0; i < 3; i++) {
        [_colomnHeightAry addObject:@(0)];
    }
    //  counts = 58 index.row = 0
    NSInteger counts = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < counts; i++) {
       
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_layoutAtrAry addObject:attri];
    }
}

//2. 内容的contentsize大小
- (CGSize)collectionViewContentSize{
    
    CGFloat collectMaxHeight = 0;
    for (int i = 0; i < _colomnRowAddUpHeightAry.count; i++) {
        CGFloat height = [_colomnRowAddUpHeightAry[i] floatValue];
        if (height > collectMaxHeight) {
            collectMaxHeight = height;
        }
    }
    NSLog(@"%s__%f", __func__, collectMaxHeight);
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, collectMaxHeight);
}


//3.当rect改变时 调用
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSLog(@"%s, %@", __func__, NSStringFromCGRect(rect));
    return _layoutAtrAry;
}

/*
 5.系统提供的方法，需手动掉用（在步骤1里面手动掉用了），返回当前indexPath的cell属性
 ⚠️也可以不用系统提供的方法，自己写一个方法返回UICollectionViewLayoutAttributes值也是可以的
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    float cellSizeWidth = [UIScreen mainScreen].bounds.size.width/_colomnRowVCount;
    float cellSizeHeight = 0;
    float cellOriginX = 0;
    float cellOriginY = 0;
    
    cellOriginX = (indexPath.row%_colomnRowVCount)*cellSizeWidth;
    cellOriginY = [_colomnRowAddUpHeightAry[indexPath.row%_colomnRowVCount] floatValue];
    cellSizeHeight = 50 + arc4random_uniform(100);
    
    
    static int doubleWidth = 1;
    doubleWidth++;
    // 占用两列的情况
    if (doubleWidth%10 == 0 && indexPath.row%3 < 2) {
        cellSizeWidth = cellSizeWidth*2;
        float currentMaxHigh = [_colomnRowAddUpHeightAry[indexPath.row%3] floatValue];
        if(currentMaxHigh < [_colomnRowAddUpHeightAry[indexPath.row%3 + 1] floatValue]){
            currentMaxHigh = [_colomnRowAddUpHeightAry[indexPath.row%3 + 1] floatValue];
        }
        
        cellOriginY = currentMaxHigh;
        _colomnRowAddUpHeightAry[indexPath.row%_colomnRowVCount + 1] = @(cellOriginY + cellSizeHeight);
    }
    
    _colomnRowAddUpHeightAry[indexPath.row%_colomnRowVCount] = @(cellOriginY + cellSizeHeight);
    layoutAttributes.frame = CGRectMake(cellOriginX, cellOriginY, cellSizeWidth, cellSizeHeight);
    return layoutAttributes;
    
}


// 4. 当滑动的时候，bounds值改变，就调用，默认返回NO，若返回YES，则reload，重新刷新内容，执行：prepareLayout，collectionViewContentSize()
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    NSLog(@"%s_%@", __func__, NSStringFromCGRect(newBounds));
    return NO;
}


@end
