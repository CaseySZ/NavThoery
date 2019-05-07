//
//  BaseInfoViewCtr.h
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>
// https://blog.csdn.net/mengtnt/article/details/6716289

/* 视图 与 图层 （视图UIView 与 图层CALayer）

 1 看UIView 描述：(An object that manages the content for a rectangular area on the screen 管理屏幕内容的对象)
 1.1 Drawing and animation // 画图和动画
 1.2 Layout and subview management // 管理内容的布局 （管理子view，如subview）
 1.3 Event handling // 控制事件
 
 那么这个对象可以分为两个模块：事件响应 和 图层（每个view都有一个CALayer属性）
 
 
 2 看CALayer 描述：（An object that manages image-based content and allows you to perform animations on that content 管理基于图像的内容，并允许您对该内容执行动画的对象）
 简而言之，就是图层，图层的功能有渲染图片,播放动画的功能 (屏幕显示的内容我们就可以看作是一张图片，系统绘制的一张图片， 那么这个绘制的过程需要数据，数据从哪里来)
 
 
 可以理解layer是一个模型对象， 他封装了几何，时间和一些可视的属性，并且提供了可以显示的内容，但是实际的显示并不是layer的职责。每一个层树的后台都有两个响应树：一个曾现树和一个渲染树）。所以很显然Layer封装了模型数据，每当更改layer中的某些模型数据中数据的属性时，曾现树都会做一个动画代替，之后由渲染树负责渲染图片。

 
 
 3 图层的使用
 
 小结： UIView可以理解为对layer层的一层封装，并通过view暴露出layer层的功能，如frame,backgroundColor, 没有暴露出来的layer的功能，如
    阴影，圆角，带颜色的边框
    3D变换
    非矩形范围
    透明遮罩
    多级非线性动画 等
 
 */


@interface BaseInfoViewCtr : UIViewController

@end


