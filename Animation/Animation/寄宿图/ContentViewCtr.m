//
//  ContentViewCtr.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ContentViewCtr.h"
#import "ContentView.h"


/*
 寄宿图，图层渲染的内容直接通过指定的内容来渲染
 
 1.1 通过属性contents， 你可以给contents属性赋任何值，你的app仍然能够编译通过,但是，在实践中，如果你给contents赋的不是CGImage，那么你得到的图层将是空白的。
 1.2 通过drawRect来绘制寄宿图，然后赋值给contents
 1.3 自己主动给contents赋值了，生成了一个寄宿图，就不会执行drawRect来重复生成寄宿图
 1.4 重写了drawRect方法后， layer.contents有值
 1.5 寄宿图并不是必须的,可以为nil，显示内容可以直接通过layer属性来渲染内容
 
 
 2 图层的代理 delegate
 2.1 _contentView.layer.delegate 的代理等于自己
 2.2 draw执行之前会先执行代理，如果代理实现了
 
 
 */

@interface ContentViewCtr (){
    
    
    ContentView *_contentView;
}

@end

@implementation ContentViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"寄宿图";
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    
    UIBarButtonItem *contentBt = [[UIBarButtonItem alloc] initWithTitle:@"contents" style:UIBarButtonItemStylePlain target:self action:@selector(contents)];
    UIBarButtonItem *drawBt = [[UIBarButtonItem alloc] initWithTitle:@"draw" style:UIBarButtonItemStylePlain target:self action:@selector(draw)];
    UIBarButtonItem *layerBt = [[UIBarButtonItem alloc] initWithTitle:@"layer" style:UIBarButtonItemStylePlain target:self action:@selector(layer)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:contentBt, drawBt, layerBt, nil];
    
    
}

- (void)contents {
    
    [_contentView removeFromSuperview];
    
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
    _contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
    _contentView.layer.contents = (__bridge id)image.CGImage;
    [self.view addSubview:_contentView];
    
}


- (void)draw {
    
    [_contentView removeFromSuperview];
    
    _contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
    _contentView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:_contentView];
    
}

- (void)layer {
    
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(100, 100, 200, 200);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [self.view.layer addSublayer:blueLayer];
    blueLayer.masksToBounds = YES;

    // 绘制
    [blueLayer display];
    
    /*
     我们在blueLayer上显式地调用了-display。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。
     尽管我们没有用masksToBounds属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持
     */
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}



@end
