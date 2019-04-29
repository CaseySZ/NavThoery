//
//  Notes.h
//  WaterFullCollection
//
//  Created by EOC on 2017/3/25.
//  Copyright © 2017年 EOC. All rights reserved.
//

#ifndef Notes_h
#define Notes_h


UICollectionView 和 UITableView
1 、UICollectionView 比 UITableView强大，可以自己控制cell布局，一般情况下，我们的UITableView布局单一，只支持行列表
    相比较可以看出，多了一个UICollectionViewLayout／UICollectionViewLayout相关代理，可以来控制cell布局

2 UICollectionView的布局由UICollectionViewLayout来完成的，自己定义cell布局有两种方式
    2.1 一种是系统提供的  UICollectionViewFlowLayout，继承UICollectionViewLayout
       2.1.1规则：一行排满，自动排到下一行
       2.1.2有两种方式来设置cell的Size， 属性和代理
            属性设置:cell都是统一大小，
            代理模式:可以控制每一个的cell大小，但是不位置不能控制，即x,y坐标由系统对齐模式控制

    2.2 一种是我们自己写每一个cell布局， 自己继承一个UICollectionViewLayout
        
    prepareLayout 为layout做准备工作，属性设置等
    collectionViewContentSize  内容的contentsize大小
    layoutAttributesForElementsInRect 返回区域内cells的属性（打印rect看大小，什么时候掉用）
    shouldInvalidateLayoutForBoundsChange当前layout的布局发生变动时，是否重写加载该layout。默认返回NO，若返回YES，则重新执行这俩方法：


    reload



#endif /* Notes_h */
