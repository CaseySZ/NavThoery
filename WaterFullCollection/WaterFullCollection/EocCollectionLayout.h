//
//  EocCollectionLayout.h
//  WaterFullCollection
//
//  Created by EOC on 2017/3/24.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EocCollectionLayout : UICollectionViewLayout{
    
    NSMutableArray *_imageUrlAry;
    NSMutableArray *_colomnRowAddUpHeightAry; // 每列的高度
    NSMutableArray *_colomnHeightAry; // cell的高度
    NSInteger _colomnRowVCount; // 列数
    NSMutableArray<UICollectionViewLayoutAttributes*> *_layoutAtrAry;
    
}

+ (NSInteger)cellCount;

- (void)setColomnRowVCount:(NSInteger)count;// 设置列数，默认3列

@end
