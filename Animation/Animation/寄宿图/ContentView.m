//
//  ContentView.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

/*
 -drawRect: 方法没有默认的实现，因为对UIView来说，寄宿图并不是必须的，它不在意那到底是单调的颜色还是有一个图片的实例。如果UIView检测到-drawRect: 方法被调用了，它就会为视图分配一个寄宿图，这个寄宿图的像素尺寸等于视图大小乘以 contentsScale的值。
 如果你不需要寄宿图，那就不要创建这个方法了，这会造成CPU资源和内存的浪费，这也是为什么苹果建议：如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法
 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
    NSLog(@"%s", __func__);
    //[super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(20, 20, 100, 100));
}


 /*
  1 渲染是，CALayer会请求displayLayer给他一个寄宿图来显示
  
  The typical technique for updating is to set the layer's contents property.
  设置layer层的contents属性
  */
//- (void)displayLayer:(CALayer *)layer {
//
//    NSLog(@"%s", __func__);
//}

/*
 2 如果代理不实现-displayLayer:方法，CALayer就会转而尝试执行drawLayer:inContext 来绘制
 在调用这个方法之前，CALayer创建了一个合适尺寸的空寄宿图（尺寸由bounds和contentsScale决定）和一个Core Graphics的绘制上下文环境，
 为绘制寄宿图做准备，他作为ctx参数传入
 */
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//
//    NSLog(@"%s", __func__);
//
//}

/*
 3 以上都没有就执行drawRect
 */



/*
 delegate小结： 当使用寄宿了视图的图层的时候，你也不必实现-displayLayer:和-drawLayer:inContext:方法来绘制你的寄宿图。
 通常做法是实现UIView的-drawRect:方法，UIView就会帮你做完剩下的工作，包括在需要重绘的时候调用-display方法
 */

@end
